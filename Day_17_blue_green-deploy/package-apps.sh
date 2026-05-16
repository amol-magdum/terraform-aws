#!/bin/bash

set -euo pipefail

# Script to package applications for Elastic Beanstalk deployment

if ! command -v zip >/dev/null 2>&1; then
    echo "[ERROR] zip command not found."
    echo "Install zip, or run the Windows script: .\\package-apps.ps1"
    exit 1
fi

echo "====================================="
echo "Packaging Applications for Deployment"
echo "====================================="
echo ""

# Package Version 1.0 (Blue)
echo "Packaging Application v1.0 (Blue)..."
cd app-v1
if [ -f "app-v1.zip" ]; then
    rm -f app-v1.zip
fi
zip -q app-v1.zip app.js package.json
if [ ! -f "app-v1.zip" ]; then
    echo "[ERROR] Failed to create app-v1/app-v1.zip"
    exit 1
fi
echo "[SUCCESS] Created app-v1/app-v1.zip"
cd ..

echo ""

# Package Version 2.0 (Green)
echo "Packaging Application v2.0 (Green)..."
cd app-v2
if [ -f "app-v2.zip" ]; then
    rm -f app-v2.zip
fi
zip -q app-v2.zip app.js package.json
if [ ! -f "app-v2.zip" ]; then
    echo "[ERROR] Failed to create app-v2/app-v2.zip"
    exit 1
fi
echo "[SUCCESS] Created app-v2/app-v2.zip"
cd ..

echo ""
echo "====================================="
echo "[SUCCESS] All applications packaged successfully!"
echo "====================================="
echo ""
echo "Next steps:"
echo "1. Run: terraform init"
echo "2. Run: terraform plan"
echo "3. Run: terraform apply"
