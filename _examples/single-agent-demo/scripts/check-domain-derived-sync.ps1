<#
check-domain-derived-sync.ps1 - Validate L2 -> L3 agent domain sync state.

Usage:
  powershell -ExecutionPolicy Bypass -File scripts/check-domain-derived-sync.ps1 -Target <derived-project>
  powershell -ExecutionPolicy Bypass -File scripts/check-domain-derived-sync.ps1 -Target <derived-project> -Advisory
#>
param(
  [string]$Source = "",
  [string]$Target = "",
  [switch]$Advisory
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

function Report-Pass {
  param([string]$Message)
  Write-Host "OK   $Message"
}

function Report-Issue {
  param([string]$Message)
  Write-Host "WARN $Message"
  $script:Issues++
}

function Report-Fail {
  param([string]$Message)
  Write-Error "FAIL $Message" -ErrorAction Continue
  $script:Failures++
}

$sourceRoot = if ($Source) { Resolve-ExistingPath $Source } else { Resolve-ExistingPath (Join-Path $PSScriptRoot "..") }
if (-not $Target) { $Target = Get-Location }
if (-not (Test-Path -LiteralPath $Target -PathType Container)) { throw "Target does not exist: $Target" }
$targetRoot = Resolve-ExistingPath $Target

$manifestPath = Join-Path $sourceRoot "domain-template-sync.json"
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
  throw "Missing domain-template-sync.json in source: $sourceRoot"
}

$manifest = Get-Content -Raw -Encoding UTF8 $manifestPath | ConvertFrom-Json
$script:Issues = 0
$script:Failures = 0

Write-Host "==> Domain derived sync check"
Write-Host "source: $sourceRoot"
Write-Host "target: $targetRoot"
Write-Host "mode: $(if ($Advisory) { 'advisory' } else { 'strict' })"
Write-Host ""

foreach ($item in @($manifest.files)) {
  $srcRel = [string]$item.source
  $dstRel = [string]$item.target
  $mode = [string]$item.mode
  $sourceFile = Join-Path $sourceRoot $srcRel
  $targetFile = Join-Path $targetRoot $dstRel

  if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) {
    Report-Fail "source missing: $srcRel"
    continue
  }

  if (-not (Test-Path -LiteralPath $targetFile -PathType Leaf)) {
    Report-Issue "target missing: $dstRel"
    continue
  }

  if ($mode -eq "overwrite-domain-owned") {
    if ((Get-FileHashText $sourceFile) -eq (Get-FileHashText $targetFile)) {
      Report-Pass "domain-owned matches: $dstRel"
    } else {
      Report-Issue "domain-owned differs: $dstRel"
    }
  } else {
    Report-Pass "project-owned exists: $dstRel"
  }
}

Write-Host ""
if ($script:Failures -gt 0) {
  Write-Error "FAIL domain derived sync check failed: $script:Failures fatal issue(s)." -ErrorAction Continue
  exit 1
}

if ($script:Issues -gt 0) {
  if ($Advisory) {
    Write-Host "OK advisory check completed with $script:Issues issue(s)."
    exit 0
  }
  Write-Error "FAIL domain derived sync check found $script:Issues issue(s)." -ErrorAction Continue
  exit 1
}

Write-Host "OK domain derived sync check passed."
