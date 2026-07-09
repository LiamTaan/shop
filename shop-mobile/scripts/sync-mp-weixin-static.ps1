$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceStatic = Join-Path $projectRoot 'static'
$targetStatic = Join-Path $projectRoot 'dist\build\mp-weixin\static'

if (!(Test-Path $sourceStatic)) {
  throw "Static source directory not found: $sourceStatic"
}

if (Test-Path $targetStatic) {
  Remove-Item -Recurse -Force $targetStatic
}

Copy-Item -Recurse -Force $sourceStatic $targetStatic
Write-Host "Synced static assets to $targetStatic"
