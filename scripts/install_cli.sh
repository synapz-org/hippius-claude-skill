#!/bin/bash
#
# Hippius CLI Installation Script
#
# This script automates the installation of the Hippius CLI (hipc)
# including prerequisite checks and environment setup.
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "  Hippius CLI Installation Script"
echo "========================================="
echo ""

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
    echo "ℹ $1"
}

# Check if Rust is installed
echo "Checking prerequisites..."
if ! command -v rustc &> /dev/null; then
    print_error "Rust is not installed"
    echo ""
    echo "Please install Rust from: https://rust-lang.org/tools/install"
    echo "Run: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    exit 1
else
    RUST_VERSION=$(rustc --version)
    print_success "Rust is installed: $RUST_VERSION"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_warning "Docker is not installed"
    echo "Docker is required for some storage operations."
    echo "Install from: https://docs.docker.com/get-docker/"
    echo ""
    read -p "Continue without Docker? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    print_success "Docker is installed"
    # Check if Docker daemon is running
    if ! docker ps &> /dev/null; then
        print_warning "Docker daemon is not running. Please start Docker."
    else
        print_success "Docker daemon is running"
    fi
fi

# Check if cargo is in PATH
if ! command -v cargo &> /dev/null; then
    print_error "Cargo is not in PATH"
    echo "Please ensure Rust's cargo is in your PATH"
    echo "Try: source \$HOME/.cargo/env"
    exit 1
fi

echo ""
echo "========================================="
echo "  Installing Hippius CLI"
echo "========================================="
echo ""

# Create temporary directory for installation
TEMP_DIR=$(mktemp -d)
print_info "Using temporary directory: $TEMP_DIR"

# Clone the repository
print_info "Cloning Hippius CLI repository..."
if git clone https://github.com/thenervelab/hipc.git "$TEMP_DIR/hipc"; then
    print_success "Repository cloned successfully"
else
    print_error "Failed to clone repository"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Build and install
cd "$TEMP_DIR/hipc"
print_info "Building Hippius CLI (this may take several minutes)..."

if cargo install --path .; then
    print_success "Hippius CLI built successfully"
else
    print_error "Failed to build Hippius CLI"
    cd -
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Copy binary to system path (optional)
if [ -f "$HOME/.cargo/bin/hipc" ]; then
    print_success "Binary installed to: $HOME/.cargo/bin/hipc"

    # Optionally copy to /usr/local/bin
    echo ""
    read -p "Copy hipc to /usr/local/bin for system-wide access? (requires sudo) (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if sudo cp "$HOME/.cargo/bin/hipc" /usr/local/bin/; then
            print_success "Binary copied to /usr/local/bin/hipc"
        else
            print_warning "Failed to copy to /usr/local/bin (continuing anyway)"
        fi
    fi
else
    print_error "Binary not found at expected location"
fi

# Clean up
cd -
rm -rf "$TEMP_DIR"
print_success "Cleaned up temporary files"

echo ""
echo "========================================="
echo "  Verifying Installation"
echo "========================================="
echo ""

# Verify installation
if command -v hipc &> /dev/null; then
    HIPC_VERSION=$(hipc --version 2>&1 || echo "version unknown")
    print_success "Hippius CLI is installed: $HIPC_VERSION"
else
    print_error "hipc command not found"
    echo "Make sure $HOME/.cargo/bin is in your PATH"
    echo "Add to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/.cargo/bin:\$PATH\""
    exit 1
fi

echo ""
echo "========================================="
echo "  Environment Configuration"
echo "========================================="
echo ""

# Check for environment configuration
if [ -f .env ]; then
    print_info ".env file found in current directory"
else
    print_warning "No .env file found"
    echo ""
    echo "To use the Hippius CLI, you need to configure:"
    echo "  1. SUBSTRATE_NODE_URL - WebSocket endpoint for Hippius node"
    echo "  2. SUBSTRATE_SEED_PHRASE - Your 12 or 24-word mnemonic phrase"
    echo ""
    read -p "Create .env file now? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Get node URL
        echo "Enter Substrate node URL (press Enter for default: ws://127.0.0.1:9944):"
        read NODE_URL
        NODE_URL=${NODE_URL:-ws://127.0.0.1:9944}

        # Get seed phrase
        echo ""
        echo "Enter your seed phrase (12 or 24 words):"
        echo "⚠ WARNING: This will be stored in plain text in .env"
        read -s SEED_PHRASE
        echo ""

        # Create .env file
        cat > .env << EOF
# Hippius CLI Configuration
SUBSTRATE_NODE_URL=$NODE_URL
SUBSTRATE_SEED_PHRASE="$SEED_PHRASE"
EOF

        # Secure the file
        chmod 600 .env
        print_success ".env file created and secured (chmod 600)"

        echo ""
        print_warning "Remember to add .env to your .gitignore!"
        echo "Run: echo '.env' >> .gitignore"
    fi
fi

echo ""
echo "========================================="
echo "  Installation Complete!"
echo "========================================="
echo ""
print_success "Hippius CLI is ready to use"
echo ""
echo "Next steps:"
echo "  1. Configure environment variables (if not done above)"
echo "  2. Source your .env file: source .env"
echo "  3. Test the CLI: hipc wallet list"
echo "  4. View all commands: hipc --help"
echo ""
echo "Documentation:"
echo "  - CLI Commands: see references/cli_commands.md"
echo "  - Authentication: see references/authentication.md"
echo "  - Storage Guide: see references/storage_guide.md"
echo ""
