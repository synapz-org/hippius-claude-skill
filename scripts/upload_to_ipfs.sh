#!/bin/bash
#
# Hippius IPFS Upload Script
#
# This script provides a convenient wrapper for uploading files to IPFS
# via the Hippius CLI with helpful output and error handling.
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if file path is provided
if [ $# -eq 0 ]; then
    print_error "No file specified"
    echo ""
    echo "Usage: $0 <file_path> [--pin]"
    echo ""
    echo "Options:"
    echo "  <file_path>    Path to file to upload"
    echo "  --pin          Pin the file (recommended for permanent storage)"
    echo ""
    echo "Examples:"
    echo "  $0 document.pdf --pin"
    echo "  $0 image.png"
    exit 1
fi

FILE_PATH="$1"
PIN_FLAG=""

# Check for --pin flag
if [ "$2" == "--pin" ]; then
    PIN_FLAG="--pin"
    print_info "File will be pinned for permanent storage"
fi

# Verify file exists
if [ ! -f "$FILE_PATH" ]; then
    print_error "File not found: $FILE_PATH"
    exit 1
fi

# Get file information
FILE_NAME=$(basename "$FILE_PATH")
FILE_SIZE=$(du -h "$FILE_PATH" | cut -f1)

print_info "Preparing to upload file:"
echo "  File: $FILE_NAME"
echo "  Size: $FILE_SIZE"
echo "  Path: $FILE_PATH"
echo ""

# Check if hipc is installed
if ! command -v hipc &> /dev/null; then
    print_error "Hippius CLI (hipc) is not installed"
    echo "Run the installation script first: scripts/install_cli.sh"
    exit 1
fi

# Check environment variables
if [ -z "$SUBSTRATE_SEED_PHRASE" ]; then
    print_warning "SUBSTRATE_SEED_PHRASE not set"
    if [ -f .env ]; then
        print_info "Loading environment from .env file"
        source .env
    else
        print_error "No .env file found and SUBSTRATE_SEED_PHRASE not set"
        echo "Please configure your environment variables"
        echo "See: references/authentication.md"
        exit 1
    fi
fi

# Upload to IPFS
echo "========================================="
echo "  Uploading to IPFS"
echo "========================================="
echo ""

if [ -n "$PIN_FLAG" ]; then
    print_info "Pinning file to IPFS..."
    if OUTPUT=$(hipc storage pin "$FILE_PATH" 2>&1); then
        print_success "File pinned successfully!"

        # Extract CID from output (assuming it's in the output)
        # This may need adjustment based on actual CLI output format
        CID=$(echo "$OUTPUT" | grep -oE 'Qm[a-zA-Z0-9]{44}' | head -1)
        if [ -n "$CID" ]; then
            echo ""
            echo "========================================="
            echo "  Upload Complete"
            echo "========================================="
            echo ""
            print_success "IPFS CID: $CID"
            echo ""
            echo "Access your file via:"
            echo "  https://ipfs.io/ipfs/$CID"
            echo "  https://gateway.pinata.cloud/ipfs/$CID"
            echo ""
            print_info "Save this CID - it's your permanent reference to the file!"

            # Optionally save to a log file
            echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") | $FILE_NAME | $CID" >> .hippius_uploads.log
            print_info "Upload logged to .hippius_uploads.log"
        else
            print_warning "Could not extract CID from output"
            echo "Full output:"
            echo "$OUTPUT"
        fi
    else
        print_error "Failed to pin file"
        echo "$OUTPUT"
        exit 1
    fi
else
    print_info "Uploading file to IPFS..."
    if OUTPUT=$(hipc storage upload "$FILE_PATH" 2>&1); then
        print_success "File uploaded successfully!"

        # Extract CID from output
        CID=$(echo "$OUTPUT" | grep -oE 'Qm[a-zA-Z0-9]{44}' | head -1)
        if [ -n "$CID" ]; then
            echo ""
            echo "========================================="
            echo "  Upload Complete"
            echo "========================================="
            echo ""
            print_success "IPFS CID: $CID"
            echo ""
            print_warning "File uploaded but NOT pinned"
            echo "For permanent storage, use: $0 $FILE_PATH --pin"
            echo ""
            echo "Access your file via:"
            echo "  https://ipfs.io/ipfs/$CID"
            echo "  https://gateway.pinata.cloud/ipfs/$CID"

            # Save to log
            echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") | $FILE_NAME | $CID | UNPINNED" >> .hippius_uploads.log
            print_info "Upload logged to .hippius_uploads.log"
        else
            print_warning "Could not extract CID from output"
            echo "Full output:"
            echo "$OUTPUT"
        fi
    else
        print_error "Failed to upload file"
        echo "$OUTPUT"
        exit 1
    fi
fi

echo ""
