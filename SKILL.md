---
name: hippius-user
description: This skill should be used when the user asks to upload files to Hippius, has questions about Hippius decentralized storage (Bittensor Subnet 75), needs to query storage status, or wants to set up the Hippius CLI for IPFS or S3-compatible storage operations.
---

# Hippius User

## Overview

Hippius is a decentralized cloud storage platform on Bittensor (Subnet 75) offering S3-compatible object storage with a decentralized backend. This skill helps users interact with Hippius for uploading files, querying storage metrics, and managing their decentralized storage account.

**IMPORTANT**: The public Hippius IPFS endpoint (`store.hippius.network`) has been deprecated with no replacement. The recommended storage path is now the **S3-compatible endpoint** (`s3.hippius.com`). The `hippius` Python CLI requires a self-hosted IPFS node for store/download commands — without one, only the S3 path works.

## When to Use This Skill

Use this skill when the user:
- Asks to upload files to Hippius
- Has questions about Hippius features, pricing, or capabilities
- Needs to query their storage status (files, buckets, usage)
- Wants to set up Hippius storage (CLI or S3)
- Needs help with Hippius authentication or environment configuration
- Asks about IPFS vs S3 storage options
- Needs to check account balance or storage credits

## Quick Start Decision Tree

```
User request about Hippius?
|
+-- "Upload file to Hippius"
|   +-> Go to: S3 Upload Workflow (recommended)
|
+-- "Set up Hippius" or "Configure storage"
|   +-> Go to: S3 Setup Workflow
|
+-- "Check my files" or "List storage"
|   +-> Go to: S3 Query Workflow
|
+-- "How does Hippius work?" or "IPFS vs S3?"
|   +-> Reference: references/storage_guide.md
|
+-- "Set up authentication"
|   +-> Reference: references/authentication.md
|
+-- "Install hippius CLI"
|   +-> Go to: CLI Installation (note: requires self-hosted IPFS node for most commands)
```

## Core Workflows

### 1. S3 Setup Workflow (Recommended)

The fastest way to use Hippius storage:

**Prerequisites:**
1. AWS CLI installed (`aws --version`) - install with `pip install awscli` or platform installer
2. Hippius S3 credentials from [console.hippius.com](https://console.hippius.com/dashboard/settings)

**Credentials:**
- Access keys start with `hip_` prefix
- Generated at console.hippius.com > Settings > API Keys
- Two types: Main keys (full access) and Sub keys (scoped access)

**Quick Setup:**
```bash
# Set credentials as environment variables
export HIPPIUS_S3_ACCESS_KEY="hip_your_access_key_here"
export HIPPIUS_S3_SECRET_KEY="your_secret_key_here"

# Or use AWS CLI directly with env vars
export AWS_ACCESS_KEY_ID="$HIPPIUS_S3_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$HIPPIUS_S3_SECRET_KEY"

# Test connection
aws --endpoint-url https://s3.hippius.com --region decentralized s3 ls
```

**Create a bucket:**
```bash
aws --endpoint-url https://s3.hippius.com --region decentralized s3 mb s3://my-bucket
```

### 2. S3 Upload Workflow

**Upload a file:**
```bash
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 cp /path/to/file.txt s3://my-bucket/file.txt
```

**Upload a directory:**
```bash
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 sync ./local-dir/ s3://my-bucket/remote-dir/
```

**Python (boto3):**
```python
import boto3

s3 = boto3.client(
    's3',
    endpoint_url='https://s3.hippius.com',
    aws_access_key_id='hip_your_access_key',
    aws_secret_access_key='your_secret_key',
    region_name='decentralized'
)

s3.upload_file('local_file.txt', 'my-bucket', 'remote_file.txt')
```

**JavaScript (MinIO client):**
```javascript
const { Client } = require('minio');

const client = new Client({
  endPoint: 's3.hippius.com',
  port: 443,
  useSSL: true,
  accessKey: 'hip_your_access_key',
  secretKey: 'your_secret_key',
  region: 'decentralized'
});

await client.fPutObject('my-bucket', 'file.txt', '/path/to/file.txt');
```

### 3. S3 Query Workflow

**List buckets:**
```bash
aws --endpoint-url https://s3.hippius.com --region decentralized s3 ls
```

**List files in a bucket:**
```bash
aws --endpoint-url https://s3.hippius.com --region decentralized s3 ls s3://my-bucket/
```

**List all files recursively:**
```bash
aws --endpoint-url https://s3.hippius.com --region decentralized s3 ls s3://my-bucket/ --recursive
```

**Download a file:**
```bash
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 cp s3://my-bucket/file.txt /local/path/file.txt
```

### 4. CLI Installation Workflow (Advanced)

The `hippius` Python CLI is available but most commands require a self-hosted IPFS node.

**Install:**
```bash
pip install hippius
```

**Configure (HIPPIUS_KEY from console.hippius.com):**
```bash
hippius config set hippius hippius_key "your_hippius_key_here"
hippius config set ipfs local_ipfs false
```

**Available commands that work without IPFS node:**
- `hippius config list` - Show configuration
- `hippius account list` - List accounts
- `hippius account login` - Login with HIPPIUS_KEY
- `hippius account login-seed` - Login with seed phrase (interactive, for miners)

**Commands that REQUIRE a self-hosted IPFS node:**
- `hippius store <file>` - Upload file
- `hippius download <CID> <output>` - Download file
- `hippius credits` - Check credits
- `hippius files` - List stored files
- `hippius pin <CID>` - Pin a CID
- `hippius exists <CID>` - Check if CID exists
- `hippius cat <CID>` - Display file content

All of these will fail with:
```
ERROR: Public https://store.hippius.network has been deprecated.
```

To use these commands, set up a local IPFS node and configure:
```bash
hippius config set ipfs api_url http://localhost:5001
hippius config set ipfs local_ipfs true
```

### 5. Authentication Setup Workflow

**For S3 (recommended):**
1. Go to [console.hippius.com](https://console.hippius.com/dashboard/settings)
2. Navigate to Settings > API Keys
3. Generate a new key pair
4. Access Key ID starts with `hip_`
5. Save both keys securely

**For CLI (advanced):**
1. Get HIPPIUS_KEY from console.hippius.com
2. Run: `hippius config set hippius hippius_key "your_key"`
3. Optionally set seed phrase: `hippius config set substrate seed_phrase "your 12 words"`

**Security Warnings:**
- Never commit credentials to version control
- Use environment variables, not hardcoded values
- Secure `.env` files: `chmod 600 .env`
- There is NO password recovery for mnemonics

## Common User Requests

### "Upload this file to Hippius"

1. Check if AWS CLI is installed (`which aws`)
2. Check for S3 credentials (`HIPPIUS_S3_ACCESS_KEY`)
3. Upload: `aws --endpoint-url https://s3.hippius.com --region decentralized s3 cp <file> s3://<bucket>/<key>`
4. Confirm upload with `s3 ls`

### "Set up Hippius for me"

1. Install AWS CLI if needed
2. Get S3 credentials from console.hippius.com
3. Set env vars: `HIPPIUS_S3_ACCESS_KEY`, `HIPPIUS_S3_SECRET_KEY`
4. Create bucket: `aws ... s3 mb s3://my-bucket`
5. Test with small upload

### "What files do I have stored?"

```bash
aws --endpoint-url https://s3.hippius.com --region decentralized s3 ls s3://bucket-name/ --recursive
```

### "Can I use IPFS with Hippius?"

The public IPFS endpoint is deprecated. Options:
1. **Self-hosted IPFS node**: Run `ipfs daemon`, then `hippius config set ipfs api_url http://localhost:5001`
2. **S3 endpoint (recommended)**: Use `s3.hippius.com` with `hip_` access keys
3. The `hippius` CLI commands (`store`, `download`, `pin`, `credits`, `files`) all require an IPFS node

## Key Facts

| Detail | Value |
|--------|-------|
| S3 Endpoint | `https://s3.hippius.com` |
| S3 Region | `decentralized` |
| Access Key Format | `hip_xxxxxxxxxxxx` |
| Console | `console.hippius.com` |
| Python CLI | `pip install hippius` |
| CLI Config | `~/.hippius/config.json` |
| IPFS Public Node | **DEPRECATED** (was `store.hippius.network`) |
| Substrate RPC | `wss://rpc.hippius.network` |

## Troubleshooting

### "Public store.hippius.network has been deprecated"

This means the `hippius` CLI cannot reach an IPFS node. Solutions:
1. **Use S3 instead** (recommended) - see S3 Setup Workflow
2. Run a local IPFS node: `ipfs daemon` and `hippius config set ipfs api_url http://localhost:5001`

### S3 Authentication Errors

- Verify access key starts with `hip_`
- Check endpoint is `https://s3.hippius.com`
- Region must be `decentralized` (not `us-east-1`)
- Keys from console.hippius.com > Settings > API Keys

### CLI Login Issues

- `hippius account login` expects HIPPIUS_KEY (API key), not seed phrase
- `hippius account login-seed` is for seed phrases but is interactive (needs TTY)
- Use `hippius config set` for non-interactive setup

## Resources

### references/

- **storage_guide.md** - IPFS vs S3 comparison, S3 code examples
- **authentication.md** - Security guide for credentials
- **cli_commands.md** - Full hippius CLI command reference
- **api_reference.md** - RPC API documentation

### External

- **Hippius Docs**: [docs.hippius.com](https://docs.hippius.com)
- **Hippius Console**: [console.hippius.com](https://console.hippius.com)
- **Hippius Stats**: [hipstats.com](https://hipstats.com)
- **CLI GitHub**: [github.com/thenervelab/hippius-cli](https://github.com/thenervelab/hippius-cli)

## Important Notes

1. **S3 is the primary path** - IPFS endpoint is deprecated, S3 works reliably
2. **Region is `decentralized`** - not `us-east-1` or any AWS region
3. **Access keys start with `hip_`** - generated at console.hippius.com
4. **No password recovery** - lost mnemonics = permanent account loss
5. **hippius CLI is limited** - most commands fail without a self-hosted IPFS node
6. **Environment security** - never commit credentials, use `.env` files with `chmod 600`
