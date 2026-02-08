# Hippius Authentication Guide

## Overview

Hippius supports two authentication methods:
1. **S3 Access Keys** (recommended) — for S3-compatible storage via `s3.hippius.com`
2. **hippius CLI Authentication** — API key or seed phrase for the `hippius` Python CLI

## S3 Authentication (Recommended)

### Obtaining S3 Credentials

1. Log in to [console.hippius.com](https://console.hippius.com)
2. Navigate to **Settings > API Keys**
3. Generate a new key pair
4. Save both keys immediately:
   - **Access Key ID**: Starts with `hip_` prefix (e.g., `hip_b11b38b2079aa749`)
   - **Secret Access Key**: Standard secret key string

Two key types are available:
- **Main keys**: Full access to all buckets and operations
- **Sub keys**: Scoped access with ACL (access control lists)

### Configuring S3 Credentials

**Environment variables (recommended):**
```bash
export HIPPIUS_S3_ACCESS_KEY="hip_your_access_key_here"
export HIPPIUS_S3_SECRET_KEY="your_secret_key_here"

# For direct aws CLI use:
export AWS_ACCESS_KEY_ID="$HIPPIUS_S3_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$HIPPIUS_S3_SECRET_KEY"
```

**Via .env file:**
```bash
# .env
HIPPIUS_S3_ACCESS_KEY=hip_your_access_key_here
HIPPIUS_S3_SECRET_KEY=your_secret_key_here
HIPPIUS_S3_BUCKET=my-bucket
```

**Test connection:**
```bash
aws --endpoint-url https://s3.hippius.com --region decentralized s3 ls
```

**IMPORTANT**: Region must be `decentralized` (not `us-east-1` or any AWS region).

### Python (boto3)

```python
import boto3

s3 = boto3.client(
    's3',
    endpoint_url='https://s3.hippius.com',
    aws_access_key_id='hip_your_access_key',
    aws_secret_access_key='your_secret_key',
    region_name='decentralized'
)
```

### JavaScript (MinIO)

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
```

## hippius CLI Authentication

The `hippius` Python CLI (`pip install hippius`) supports two auth methods.

**Note**: Most file operation commands (`store`, `download`, `credits`, `files`) require a self-hosted IPFS node since the public endpoint is deprecated. For storage operations, use S3 instead.

### Method 1: HIPPIUS_KEY (API Key)

Get your API key from [console.hippius.com](https://console.hippius.com).

**Interactive login** (requires TTY):
```bash
hippius account login
```

**Non-interactive setup** (for scripts/containers):
```bash
hippius config set hippius hippius_key "your_hippius_key_here"
```

### Method 2: Seed Phrase (for miners/blockchain operations)

Only needed if you perform blockchain transactions (pinning, staking, etc.).

**Interactive login** (requires TTY):
```bash
hippius account login-seed
```

**Non-interactive setup**:
```bash
hippius config set substrate seed_phrase "your twelve word mnemonic phrase here"
```

### CLI Configuration

Configuration is stored at `~/.hippius/config.json`.

```bash
# View all config
hippius config list

# Set IPFS to remote (no local node)
hippius config set ipfs local_ipfs false

# Set custom IPFS node (if self-hosting)
hippius config set ipfs api_url http://localhost:5001

# Set Substrate RPC URL
hippius config set substrate url wss://rpc.hippius.network
```

## Critical Security Warning

**There is NO password recovery in Hippius.** Lost mnemonics = permanent account loss.

**Always:**
- Write down mnemonic phrases on paper and store securely
- Never share mnemonics or API keys with anyone
- Never commit credentials to version control
- Use `.env` files with `chmod 600` permissions
- Add `.env` to `.gitignore`

## Security Best Practices

### Protecting Credentials

1. **File permissions**: Secure `.env` files
   ```bash
   chmod 600 .env
   ```

2. **Git ignore**: Prevent accidental commits
   ```
   .env
   .env.local
   ```

3. **Environment variables**: Prefer env vars over hardcoded values

4. **Limit exposure**: Unset sensitive variables when done
   ```bash
   unset HIPPIUS_S3_SECRET_KEY
   unset AWS_SECRET_ACCESS_KEY
   ```

### Protecting Seed Phrases

1. **Offline storage**: Write on paper, never store digitally
2. **Multiple backups**: Store copies in different secure locations
3. **Metal backups**: Consider fireproof/waterproof metal seed phrase storage
4. **No photos**: Don't photograph your seed phrase
5. **No cloud storage**: Never store in Dropbox, Google Drive, etc.
6. **Verify backups**: Test recovery to ensure accuracy

## Troubleshooting

### S3 Authentication Errors

- Verify access key starts with `hip_`
- Check endpoint is `https://s3.hippius.com`
- Region must be `decentralized`
- Verify keys haven't been revoked at console.hippius.com
- Check account has sufficient credits

### CLI "Public store.hippius.network has been deprecated"

This means no IPFS node is available. Options:
1. **Use S3 instead** (recommended)
2. Run a local IPFS node: `ipfs daemon` then `hippius config set ipfs api_url http://localhost:5001`

### CLI Login Issues

- `hippius account login` and `hippius account login-seed` are interactive (require TTY)
- For non-interactive environments, use `hippius config set` directly
- HIPPIUS_KEY is an API key from console.hippius.com (not a seed phrase)

## Resources

- **Hippius Console**: [console.hippius.com](https://console.hippius.com)
- **Hippius Docs**: [docs.hippius.com](https://docs.hippius.com)
- **Hippius Stats**: [hipstats.com](https://hipstats.com)
