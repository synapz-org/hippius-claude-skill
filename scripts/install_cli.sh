#!/bin/bash
#
# Hippius CLI Installation Script
#
# Installs the hippius Python CLI and configures it for use.
# The recommended storage path is S3 (s3.hippius.com) — most hippius CLI
# file commands require a self-hosted IPFS node since the public endpoint
# is deprecated.
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_error() { echo -e "${RED}ERROR: $1${NC}"; }
print_success() { echo -e "${GREEN}$1${NC}"; }
print_warning() { echo -e "${YELLOW}$1${NC}"; }
print_info() { echo -e "${BLUE}$1${NC}"; }

echo "========================================="
echo "  Hippius CLI Installation Script"
echo "========================================="
echo ""

# Check Python
echo "Checking prerequisites..."
if command -v python3 &> /dev/null; then
    PY_VERSION=$(python3 --version)
    print_success "Python3 is installed: $PY_VERSION"
else
    print_error "Python3 is not installed"
    echo "Install Python 3 from: https://python.org/downloads/"
    exit 1
fi

# Check pip
if command -v pip3 &> /dev/null; then
    print_success "pip3 is available"
elif command -v pip &> /dev/null; then
    print_success "pip is available"
else
    print_error "pip is not installed"
    echo "Install with: python3 -m ensurepip --upgrade"
    exit 1
fi

# Check if hippius is already installed
if command -v hippius &> /dev/null; then
    CURRENT_VERSION=$(hippius --version 2>&1 || echo "unknown")
    print_warning "hippius is already installed: $CURRENT_VERSION"
    echo ""
    read -p "Upgrade to latest version? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pip3 install --upgrade hippius
    else
        echo "Keeping current version."
    fi
else
    echo ""
    echo "========================================="
    echo "  Installing hippius CLI"
    echo "========================================="
    echo ""

    if pip3 install hippius; then
        print_success "hippius CLI installed successfully"
    else
        print_error "Failed to install hippius"
        echo "Try: pip3 install --user hippius"
        exit 1
    fi
fi

echo ""
echo "========================================="
echo "  Verifying Installation"
echo "========================================="
echo ""

if command -v hippius &> /dev/null; then
    HIPPIUS_VERSION=$(hippius --version 2>&1 || echo "version unknown")
    print_success "hippius CLI is installed: $HIPPIUS_VERSION"
else
    print_error "hippius command not found after installation"
    echo "Ensure pip install directory is in your PATH"
    echo "Try: python3 -m hippius --version"
    exit 1
fi

# Check for AWS CLI (needed for S3 operations)
echo ""
if command -v aws &> /dev/null; then
    AWS_VERSION=$(aws --version 2>&1)
    print_success "AWS CLI is installed: $AWS_VERSION"
else
    print_warning "AWS CLI is not installed (needed for S3 storage)"
    echo "Install with: pip3 install awscli"
    echo "Or see: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html"
fi

echo ""
echo "========================================="
echo "  Configuration"
echo "========================================="
echo ""

print_info "Configuring hippius CLI..."

# Disable local IPFS by default (public endpoint is deprecated)
hippius config set ipfs local_ipfs false 2>/dev/null || true
print_success "Set local_ipfs = false (public IPFS endpoint is deprecated)"

echo ""
print_warning "IMPORTANT: The public Hippius IPFS endpoint (store.hippius.network)"
print_warning "has been deprecated. For storage operations, use the S3 endpoint:"
print_warning "  Endpoint: https://s3.hippius.com"
print_warning "  Region: decentralized"
print_warning "  Get access keys from: https://console.hippius.com/dashboard/settings"
echo ""

# Check for environment configuration
if [ -f .env ]; then
    print_info ".env file found in current directory"
else
    print_warning "No .env file found"
    echo ""
    echo "To use Hippius S3 storage, create a .env file with:"
    echo "  HIPPIUS_S3_ACCESS_KEY=hip_your_access_key_here"
    echo "  HIPPIUS_S3_SECRET_KEY=your_secret_key_here"
    echo "  HIPPIUS_S3_BUCKET=my-bucket"
    echo ""
    echo "Get credentials from: https://console.hippius.com/dashboard/settings"
    echo "Access keys start with the 'hip_' prefix."
fi

echo ""
echo "========================================="
echo "  Installation Complete!"
echo "========================================="
echo ""
print_success "hippius CLI is ready to use"
echo ""
echo "For S3 storage (recommended):"
echo "  1. Get S3 credentials from console.hippius.com"
echo "  2. Set env vars: HIPPIUS_S3_ACCESS_KEY, HIPPIUS_S3_SECRET_KEY"
echo "  3. Test: aws --endpoint-url https://s3.hippius.com --region decentralized s3 ls"
echo ""
echo "For hippius CLI (requires self-hosted IPFS node for file commands):"
echo "  1. Set API key: hippius config set hippius hippius_key \"your_key\""
echo "  2. View config: hippius config list"
echo "  3. See all commands: hippius --help"
echo ""
echo "Documentation:"
echo "  - CLI Commands: see references/cli_commands.md"
echo "  - Authentication: see references/authentication.md"
echo "  - Storage Guide: see references/storage_guide.md"
echo ""
