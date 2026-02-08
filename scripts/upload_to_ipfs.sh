#!/bin/bash
#
# Hippius S3 Upload Script
#
# Upload files to Hippius decentralized storage via S3-compatible endpoint.
# Note: The old IPFS upload path (hipc/hippius store) is deprecated.
# This script uses the S3 endpoint which is the recommended storage path.
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

if [ $# -eq 0 ]; then
    print_error "No file specified"
    echo ""
    echo "Usage: $0 <file_path> [s3-key] [--bucket <bucket>]"
    echo ""
    echo "Options:"
    echo "  <file_path>       Path to file to upload"
    echo "  [s3-key]          S3 key/path (default: files/<filename>)"
    echo "  --bucket <name>   S3 bucket name (default: \$HIPPIUS_S3_BUCKET or 'hippius-storage')"
    echo ""
    echo "Environment:"
    echo "  HIPPIUS_S3_ACCESS_KEY  Access key (hip_xxx format, from console.hippius.com)"
    echo "  HIPPIUS_S3_SECRET_KEY  Secret key"
    echo "  HIPPIUS_S3_BUCKET      Default bucket name"
    echo ""
    echo "Examples:"
    echo "  $0 document.pdf"
    echo "  $0 image.png images/photo.png"
    echo "  $0 data.csv --bucket my-data-bucket"
    exit 1
fi

FILE_PATH="$1"
S3_KEY=""
BUCKET="${HIPPIUS_S3_BUCKET:-hippius-storage}"

# Parse arguments
shift
while [ $# -gt 0 ]; do
    case "$1" in
        --bucket)
            BUCKET="$2"
            shift 2
            ;;
        *)
            S3_KEY="$1"
            shift
            ;;
    esac
done

# Default S3 key from filename
if [ -z "$S3_KEY" ]; then
    S3_KEY="files/$(basename "$FILE_PATH")"
fi

# Verify file exists
if [ ! -f "$FILE_PATH" ]; then
    print_error "File not found: $FILE_PATH"
    exit 1
fi

FILE_NAME=$(basename "$FILE_PATH")
FILE_SIZE=$(du -h "$FILE_PATH" | cut -f1)

print_info "Preparing to upload file:"
echo "  File: $FILE_NAME"
echo "  Size: $FILE_SIZE"
echo "  Bucket: $BUCKET"
echo "  Key: $S3_KEY"
echo ""

# Check aws CLI
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI not installed"
    echo "Install with: pip install awscli"
    exit 1
fi

# Check credentials
if [ -z "$HIPPIUS_S3_ACCESS_KEY" ] || [ -z "$HIPPIUS_S3_SECRET_KEY" ]; then
    # Try loading from .env
    if [ -f .env ]; then
        print_info "Loading credentials from .env"
        source .env
    fi

    if [ -z "$HIPPIUS_S3_ACCESS_KEY" ] || [ -z "$HIPPIUS_S3_SECRET_KEY" ]; then
        print_error "HIPPIUS_S3_ACCESS_KEY and HIPPIUS_S3_SECRET_KEY must be set"
        echo "Get credentials from: https://console.hippius.com/dashboard/settings"
        exit 1
    fi
fi

export AWS_ACCESS_KEY_ID="$HIPPIUS_S3_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$HIPPIUS_S3_SECRET_KEY"

S3_ENDPOINT="https://s3.hippius.com"
S3_REGION="decentralized"

echo "========================================="
echo "  Uploading to Hippius S3"
echo "========================================="
echo ""

if OUTPUT=$(aws --endpoint-url "$S3_ENDPOINT" --region "$S3_REGION" \
    s3 cp "$FILE_PATH" "s3://$BUCKET/$S3_KEY" 2>&1); then

    echo ""
    echo "========================================="
    echo "  Upload Complete"
    echo "========================================="
    echo ""
    print_success "Uploaded to: s3://$BUCKET/$S3_KEY"
    echo ""
    echo "Download with:"
    echo "  aws --endpoint-url $S3_ENDPOINT --region $S3_REGION \\"
    echo "      s3 cp s3://$BUCKET/$S3_KEY ./$FILE_NAME"
    echo ""

    # Log upload
    echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") | $FILE_NAME | s3://$BUCKET/$S3_KEY" >> .hippius_uploads.log
    print_info "Upload logged to .hippius_uploads.log"
else
    print_error "Failed to upload file"
    echo "$OUTPUT"
    exit 1
fi

echo ""
