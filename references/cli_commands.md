# Hippius CLI Commands Reference

## Overview

The Hippius CLI (`hippius`) is a Python-based command-line tool for IPFS and blockchain storage operations on the Hippius network (Bittensor Subnet 75).

**IMPORTANT**: The public IPFS endpoint (`store.hippius.network`) is deprecated. Most file operation commands (`store`, `download`, `credits`, `files`, etc.) require a self-hosted IPFS node. For most users, the **S3 endpoint** (`s3.hippius.com`) is the recommended storage path.

## Installation

```bash
pip install hippius
```

Or via conda/pipx:
```bash
pipx install hippius
```

## Configuration

Configuration is stored at `~/.hippius/config.json`.

### View Configuration
```bash
hippius config list
```

### Set Configuration Values
```bash
# Set HIPPIUS_KEY (API key from console.hippius.com)
hippius config set hippius hippius_key "your_hippius_key"

# Set seed phrase for blockchain operations
hippius config set substrate seed_phrase "your twelve word mnemonic here"

# Disable local IPFS (use remote)
hippius config set ipfs local_ipfs false

# Set custom IPFS API URL (required if not using local IPFS)
hippius config set ipfs api_url http://your-ipfs-node:5001

# Set Substrate RPC URL
hippius config set substrate url wss://rpc.hippius.network
```

### Import from .env file
```bash
hippius config import-env
```

### Reset to defaults
```bash
hippius config reset
```

## Account Management

### Login with HIPPIUS_KEY (recommended)
```bash
hippius account login
```
Interactive prompt for HIPPIUS_KEY from console.hippius.com.

### Login with Seed Phrase (for miners)
```bash
hippius account login-seed
```
Interactive prompt for account name and 12/24-word mnemonic. Note: this is for miners who need to sign blockchain transactions.

### List Accounts
```bash
hippius account list
```

### Account Info
```bash
hippius account info
```

### Switch Account
```bash
hippius account switch
```

### Account Balance
```bash
hippius account balance
```

### Export/Import Account
```bash
hippius account export
hippius account import
```

### Delete Account
```bash
hippius account delete
```

## File Operations (Require IPFS Node)

**All commands below require a configured IPFS node URL.** Without one, they fail with: `ERROR: Public https://store.hippius.network has been deprecated.`

### Store (Upload) a File
```bash
hippius store <file_path>

# Without encryption
hippius store <file_path> --no-encrypt

# With encryption
hippius store <file_path> --encrypt
```

### Download a File
```bash
hippius download <CID> <output_path>

# Without decryption
hippius download <CID> <output_path> --no-decrypt
```

### Store a Directory
```bash
hippius store-dir <directory_path>
```

### Check if CID Exists
```bash
hippius exists <CID>
```

### View File Content
```bash
hippius cat <CID>
```

### Pin a CID
```bash
# Pin and publish to blockchain
hippius pin <CID>

# Pin without blockchain publish
hippius pin <CID> --no-publish
```

### Delete a File
```bash
hippius delete <CID>
```

### List Your Files
```bash
hippius files

# Show all miners for each file
hippius files --all-miners
```

### Check Credits
```bash
hippius credits
```

## Erasure Coding (Require IPFS Node)

### Erasure Code a File
```bash
# Default settings (k=3, m=5)
hippius erasure-code <file_path>

# Custom parameters
hippius erasure-code <file_path> --k 3 --m 5

# Without publishing to global IPFS
hippius erasure-code <file_path> --no-publish
```

### Reconstruct a File
```bash
hippius reconstruct <metadata_CID> <output_path>
```

### List Erasure-Coded Files
```bash
hippius ec-files
```

### Delete Erasure-Coded File
```bash
hippius ec-delete <metadata_CID>
```

## Encryption

### Generate Encryption Key
```bash
hippius keygen
```

### Use Encryption with Uploads
```bash
# Encrypt by default
hippius config set encryption encrypt_by_default true

# Or per-command
hippius store <file> --encrypt --encryption-key <base64_key>
```

## Global Options

```
--api-url <URL>       Custom IPFS API URL
--local-ipfs          Use local IPFS node (localhost:5001)
--substrate-url <URL> Custom Substrate WebSocket URL
--miner-ids <IDs>     Comma-separated miner IDs
--verbose / -v        Enable debug output
--encrypt             Encrypt files when uploading
--no-encrypt          Skip encryption
--decrypt             Decrypt files when downloading
--no-decrypt          Skip decryption
--hippius-key <KEY>   Override HIPPIUS_KEY
--account <NAME>      Use specific account
```

## S3 Alternative (Recommended)

Since the IPFS endpoint is deprecated, use the S3-compatible endpoint instead:

```bash
# Set credentials
export AWS_ACCESS_KEY_ID="hip_your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"

# Upload
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 cp file.txt s3://my-bucket/file.txt

# Download
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 cp s3://my-bucket/file.txt ./file.txt

# List files
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 ls s3://my-bucket/

# Create bucket
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 mb s3://my-bucket
```

Get S3 credentials (`hip_` prefix keys) from [console.hippius.com](https://console.hippius.com/dashboard/settings).

## Troubleshooting

### "Public store.hippius.network has been deprecated"

All file operation commands require an IPFS node. Options:
1. Use S3 endpoint instead (recommended)
2. Run local IPFS: `ipfs daemon` then `hippius config set ipfs api_url http://localhost:5001`

### Login Issues

- `hippius account login` and `hippius account login-seed` are interactive (require TTY)
- For non-interactive setup, use `hippius config set` directly
- HIPPIUS_KEY is an API key from console.hippius.com (not a seed phrase)

### Config Location

Configuration file: `~/.hippius/config.json`

Default values:
- Substrate URL: `wss://rpc.hippius.network`
- IPFS local: `true` (set to `false` for remote)
- Encryption: `false` by default
