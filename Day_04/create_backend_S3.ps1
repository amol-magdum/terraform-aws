$ErrorActionPreference = 'Stop'

$BucketName = "terraform-state-$([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())"
$Region = "us-east-1"

function Invoke-Aws {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    & aws @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "AWS CLI command failed: aws $($Arguments -join ' ')"
    }
}

Write-Host "Creating S3 bucket: $BucketName in region: $Region"

# us-east-1 does not require LocationConstraint on create-bucket.
if ($Region -eq "us-east-1") {
    Invoke-Aws -Arguments @("s3api", "create-bucket", "--bucket", $BucketName) | Out-Null
} else {
    Invoke-Aws -Arguments @("s3api", "create-bucket", "--bucket", $BucketName, "--create-bucket-configuration", "LocationConstraint=$Region") | Out-Null
}

Write-Host "Enabling bucket versioning..."
Invoke-Aws -Arguments @("s3api", "put-bucket-versioning", "--bucket", $BucketName, "--versioning-configuration", "Status=Enabled") | Out-Null

Write-Host "Enabling bucket encryption (AES256)..."
$EncryptionConfig = @{
    Rules = @(
        @{
            ApplyServerSideEncryptionByDefault = @{
                SSEAlgorithm = "AES256"
            }
        }
    )
} | ConvertTo-Json -Compress -Depth 5

$TempEncryptionFile = Join-Path $env:TEMP ("terraform-s3-encryption-{0}.json" -f $BucketName)
Set-Content -Path $TempEncryptionFile -Value $EncryptionConfig -Encoding utf8
Invoke-Aws -Arguments @("s3api", "put-bucket-encryption", "--bucket", $BucketName, "--server-side-encryption-configuration", "file://$TempEncryptionFile") | Out-Null
Remove-Item -Path $TempEncryptionFile -ErrorAction SilentlyContinue

Write-Host "======================================"
Write-Host "S3 Backend Setup Complete!"
Write-Host "======================================"
Write-Host "Bucket Name: $BucketName"
Write-Host "Region: $Region"
Write-Host "Versioning: Enabled (required for state locking)"
Write-Host "Encryption: Enabled (AES256)"
Write-Host ""
Write-Host "State Locking Method: S3 Native State Locking"
Write-Host "  - Uses S3 Conditional Writes (If-None-Match header)"
Write-Host "  - Creates temporary .tflock files in S3"
Write-Host "  - No DynamoDB required (previously used)"
Write-Host "  - Available in Terraform 1.10+ (stable in 1.11+)"
Write-Host ""
Write-Host "======================================"
Write-Host "Update your backend.tf with:"
Write-Host "======================================"
Write-Host ""
Write-Host "terraform {"
Write-Host '  backend "s3" {'
Write-Host ('    bucket       = "{0}"' -f $BucketName)
Write-Host '    key          = "dev/terraform.tfstate"'
Write-Host ('    region       = "{0}"' -f $Region)
Write-Host "    use_lockfile = true"
Write-Host "    encrypt      = true"
Write-Host "  }"
Write-Host "}"
Write-Host ""
Write-Host "Then run: terraform init"
