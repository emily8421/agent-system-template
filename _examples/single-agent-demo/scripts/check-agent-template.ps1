<#
check-agent-template.ps1 - Advisory-first agent scaffold and traceability check.

Usage:
  powershell -ExecutionPolicy Bypass -File scripts/check-agent-template.ps1
  powershell -ExecutionPolicy Bypass -File scripts/check-agent-template.ps1 -Target <agent-project>

This script exits non-zero only for fatal parse/runtime errors. Missing scaffold or weak traceability are advisory findings by D8.
#>
param(
  [string]$Target = ""
)

$ErrorActionPreference = "Stop"

function Resolve-ExistingPath {
  param([string]$Path)
  return (Resolve-Path -LiteralPath $Path).Path
}

function Add-Finding {
  param([string]$Message)
  Write-Host "WARN $Message"
  $script:Findings++
}

function Pass {
  param([string]$Message)
  Write-Host "OK   $Message"
}

function Test-RequiredFile {
  param([string]$RelativePath)

  $path = Join-Path $targetRoot $RelativePath
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Pass "file exists: $RelativePath"
  } else {
    Add-Finding "missing file: $RelativePath"
  }
}

function Get-AllMarkdownText {
  $files = @(Get-ChildItem -LiteralPath $targetRoot -Recurse -File -Filter *.md -ErrorAction SilentlyContinue)
  $texts = New-Object System.Collections.Generic.List[string]
  foreach ($file in $files) {
    try {
      $texts.Add((Get-Content -Raw -Encoding UTF8 $file.FullName)) | Out-Null
    } catch {
      Add-Finding "cannot read markdown: $($file.FullName)"
    }
  }
  return ($texts -join "`n")
}

if (-not $Target) { $Target = Get-Location }
if (-not (Test-Path -LiteralPath $Target -PathType Container)) { throw "Target does not exist: $Target" }
$targetRoot = Resolve-ExistingPath $Target
$script:Findings = 0

Write-Host "==> Agent template advisory check"
Write-Host "target: $targetRoot"
Write-Host "strength: advisory-first"
Write-Host ""

$required = @(
  "README.md",
  "TEMPLATE-BASE.md",
  "ai/project-rules.md",
  "docs/00-scenario.md",
  "docs/01-user-requirements.md",
  "docs/02-srs.md",
  "docs/03-prd.md",
  "docs/04-architecture.md",
  "docs/05-tech-spec.md",
  "docs/08-dev-plan.md",
  "docs/09-verification.md",
  "docs/design/agent-architecture.md",
  "docs/design/tool-permission-model.md",
  "docs/design/memory-and-state.md",
  "docs/design/trace-and-replay.md",
  "docs/design/hitl-and-safety.md",
  "docs/research/agent-eval-plan.md"
)

foreach ($file in $required) {
  Test-RequiredFile $file
}

$overlay = @(
  "ai/agent-rules/agent-implementation-rules.md",
  "ai/agent-rules/tool-safety-rules.md",
  "ai/doc-standards/agent-architecture.md",
  "ai/doc-standards/agent-tool-permission-model.md",
  "ai/doc-standards/agent-memory-and-state.md",
  "ai/doc-standards/agent-trace-and-replay.md",
  "ai/doc-standards/agent-hitl-and-safety.md",
  "ai/doc-standards/agent-eval-plan.md"
)

foreach ($file in $overlay) {
  $path = Join-Path $targetRoot $file
  if (Test-Path -LiteralPath $path -PathType Leaf) {
    Pass "domain overlay exists: $file"
  } else {
    Add-Finding "domain overlay missing or not yet synced: $file"
  }
}

Write-Host ""
Write-Host "==> Traceability"
$allText = Get-AllMarkdownText
if ($allText -match 'REQ-[0-9A-Za-z-]+') {
  Pass "REQ-ID found in project docs"
} else {
  Add-Finding "no REQ-ID found in project docs"
}

if ($allText -match 'TC-[0-9A-Za-z-]+') {
  Pass "TC-ID found in project docs"
} else {
  Add-Finding "no TC-ID found in project docs"
}

$mappingPath = Join-Path $targetRoot "docs/research/agent-standard-mapping.md"
if (Test-Path -LiteralPath $mappingPath -PathType Leaf) {
  $mapping = Get-Content -Raw -Encoding UTF8 $mappingPath
  if ($mapping -match 'REQ-' -and $mapping -match 'TC-' -and $mapping -match 'L2 Standard') {
    Pass "agent standard mapping links L2 standards to REQ/TC"
  } else {
    Add-Finding "agent standard mapping exists but lacks L2/REQ/TC links"
  }
} else {
  Add-Finding "agent standard mapping missing: docs/research/agent-standard-mapping.md"
}

Write-Host ""
Write-Host "OK advisory check completed with $script:Findings finding(s)."
exit 0
