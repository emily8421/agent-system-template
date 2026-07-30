<#
sync-domain-template.ps1 - L2 agent domain template -> L3 agent project sync.

Usage:
  powershell -ExecutionPolicy Bypass -File scripts/sync-domain-template.ps1 -Target <derived-project> -DryRun
  powershell -ExecutionPolicy Bypass -File scripts/sync-domain-template.ps1 -Target <derived-project> -Commit
  powershell -ExecutionPolicy Bypass -File scripts/sync-domain-template.ps1 -Source <agent-system-template> -Target <derived-project> -DryRun

Commit mode copies files and creates a git commit only when Target is an independent git root with a clean working tree.
Project-owned files use copy-if-missing and are never overwritten by default.
#>
param(
  [string]$Source = "",
  [string]$Target = "",
  [switch]$DryRun,
  [switch]$Commit
)

$ErrorActionPreference = "Stop"

function Resolve-ExistingPath {
  param([string]$Path)
  return (Resolve-Path -LiteralPath $Path).Path
}

function Get-FileHashText {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return "" }
  return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
}

function Copy-Utf8File {
  param(
    [string]$From,
    [string]$To
  )

  $parent = Split-Path -Parent $To
  if ($parent) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
  Copy-Item -LiteralPath $From -Destination $To -Force
}

function Get-RelativePathForGit {
  param(
    [string]$Root,
    [string]$Path
  )

  $rootFull = [System.IO.Path]::GetFullPath($Root).TrimEnd('\', '/')
  $pathFull = [System.IO.Path]::GetFullPath($Path)
  return [System.IO.Path]::GetRelativePath($rootFull, $pathFull).Replace('\', '/')
}

function Get-GitRoot {
  param([string]$Path)

  $out = & git -C $Path rev-parse --show-toplevel 2>$null
  if ($LASTEXITCODE -ne 0) { return "" }
  return (($out | Select-Object -First 1) -replace '/', '\')
}

if (-not $DryRun -and -not $Commit) { $DryRun = $true }
if ($DryRun -and $Commit) { throw "Choose only one mode: -DryRun or -Commit." }

$sourceRoot = if ($Source) { Resolve-ExistingPath $Source } else { Resolve-ExistingPath (Join-Path $PSScriptRoot "..") }
if (-not $Target) {
  $current = Resolve-ExistingPath (Get-Location)
  if ($current -eq $sourceRoot) {
    throw "Target is required when running from the domain template root."
  }
  $Target = $current
}

if (-not (Test-Path -LiteralPath $Target -PathType Container)) {
  if ($Commit) {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
  } else {
    throw "Target does not exist: $Target"
  }
}
$targetRoot = Resolve-ExistingPath $Target

$manifestPath = Join-Path $sourceRoot "domain-template-sync.json"
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
  throw "Missing domain-template-sync.json in source: $sourceRoot"
}

$manifest = Get-Content -Raw -Encoding UTF8 $manifestPath | ConvertFrom-Json
$versionFile = Join-Path $sourceRoot $manifest.source.version_file
$domainVersion = if (Test-Path -LiteralPath $versionFile -PathType Leaf) { (Get-Content -Raw -Encoding UTF8 $versionFile).Trim() } else { "unknown" }
$modeLabel = if ($Commit) { "commit" } else { "dry-run" }

Write-Host "==> Agent domain template sync ($modeLabel)"
Write-Host "source: $sourceRoot"
Write-Host "target: $targetRoot"
Write-Host "version: $domainVersion"
Write-Host "policy: project facts copy-if-missing; domain-owned files may update"
Write-Host ""

$gitRoot = Get-GitRoot $targetRoot
$targetIsGitRoot = $false
if ($gitRoot) {
  $targetIsGitRoot = ((Resolve-ExistingPath $gitRoot) -eq $targetRoot)
}
if ($Commit -and $targetIsGitRoot) {
  $dirty = @(& git -C $targetRoot status --porcelain)
  if ($dirty.Count -gt 0) {
    throw "Target git working tree is not clean. Commit or stash target changes before domain sync."
  }
}

$errors = 0
$changed = New-Object System.Collections.Generic.List[string]
$skipped = New-Object System.Collections.Generic.List[string]

foreach ($item in @($manifest.files)) {
  $srcRel = [string]$item.source
  $dstRel = [string]$item.target
  $mode = [string]$item.mode
  $sourceFile = Join-Path $sourceRoot $srcRel
  $targetFile = Join-Path $targetRoot $dstRel

  if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) {
    Write-Error "missing source file: $srcRel" -ErrorAction Continue
    $errors++
    continue
  }

  $targetExists = Test-Path -LiteralPath $targetFile -PathType Leaf
  $same = $false
  if ($targetExists) {
    $same = ((Get-FileHashText $sourceFile) -eq (Get-FileHashText $targetFile))
  }

  if (-not $targetExists) {
    Write-Host "ADD  $dstRel <= $srcRel"
    if ($Commit) {
      Copy-Utf8File -From $sourceFile -To $targetFile
      $changed.Add($dstRel) | Out-Null
    }
    continue
  }

  if ($same) {
    Write-Host "OK   $dstRel"
    continue
  }

  if ($mode -eq "overwrite-domain-owned") {
    Write-Host "UPD  $dstRel <= $srcRel"
    if ($Commit) {
      Copy-Utf8File -From $sourceFile -To $targetFile
      $changed.Add($dstRel) | Out-Null
    }
  } else {
    Write-Host "SKIP $dstRel (project-owned exists; not overwritten)"
    $skipped.Add($dstRel) | Out-Null
  }
}

if ($errors -gt 0) {
  throw "Domain sync cannot continue: $errors missing source file(s)."
}

Write-Host ""
if ($DryRun) {
  Write-Host "INFO dry-run only; target unchanged."
  Write-Host "     Apply after review: powershell -ExecutionPolicy Bypass -File scripts\sync-domain-template.ps1 -Source <source> -Target <target> -Commit"
  exit 0
}

if ($changed.Count -eq 0) {
  Write-Host "INFO no files changed."
  exit 0
}

Write-Host "Changed files: $($changed.Count)"
if ($targetIsGitRoot) {
  $gitPaths = @()
  foreach ($rel in $changed) {
    $gitPaths += $rel
  }
  & git -C $targetRoot add -- $gitPaths
  if ($LASTEXITCODE -ne 0) { throw "git add failed in target." }
  & git -C $targetRoot diff --cached --quiet
  if ($LASTEXITCODE -eq 1) {
    $message = ($manifest.policy.commit_message -replace '\{version\}', $domainVersion)
    & git -C $targetRoot commit -m $message
    if ($LASTEXITCODE -ne 0) { throw "git commit failed in target." }
    Write-Host "OK committed in target: $message"
  } elseif ($LASTEXITCODE -eq 0) {
    Write-Host "INFO git index has no changes to commit."
  } else {
    throw "git diff --cached failed in target."
  }
} else {
  Write-Host "INFO target is not an independent git root; files were copied but no git commit was created."
}
