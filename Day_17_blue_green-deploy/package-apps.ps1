# Script to package applications for Elastic Beanstalk deployment on Windows

$ErrorActionPreference = 'Stop'

Write-Host "====================================="
Write-Host "Packaging Applications for Deployment"
Write-Host "====================================="
Write-Host ""

function New-AppPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$AppFolder,

        [Parameter(Mandatory = $true)]
        [string]$ZipName,

        [Parameter(Mandatory = $true)]
        [string]$Label
    )

    Write-Host "Packaging Application $Label..."

    if (-not (Test-Path $AppFolder)) {
        throw "Folder '$AppFolder' not found."
    }

    $zipPath = Join-Path $AppFolder $ZipName

    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }

    $appJs = Join-Path $AppFolder 'app.js'
    $packageJson = Join-Path $AppFolder 'package.json'

    if (-not (Test-Path $appJs)) {
        throw "Missing file: $appJs"
    }

    if (-not (Test-Path $packageJson)) {
        throw "Missing file: $packageJson"
    }

    Compress-Archive -Path $appJs, $packageJson -DestinationPath $zipPath -CompressionLevel Optimal -Force

    if (-not (Test-Path $zipPath)) {
        throw "Failed to create package: $zipPath"
    }

    Write-Host "[SUCCESS] Created $AppFolder/$ZipName"
    Write-Host ""
}

New-AppPackage -AppFolder 'app-v1' -ZipName 'app-v1.zip' -Label 'v1.0 (Blue)'
New-AppPackage -AppFolder 'app-v2' -ZipName 'app-v2.zip' -Label 'v2.0 (Green)'

Write-Host "====================================="
Write-Host "[SUCCESS] All applications packaged successfully!"
Write-Host "====================================="
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Run: terraform init"
Write-Host "2. Run: terraform plan"
Write-Host "3. Run: terraform apply"
