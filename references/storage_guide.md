# Hippius Storage Guide

## Overview

Hippius offers two storage solutions: IPFS-based decentralized storage and S3-compatible hybrid storage. **As of 2026, the S3 endpoint is the recommended path** since the public IPFS node has been deprecated.

## Current Status

| Storage Type | Status | Endpoint |
|-------------|--------|----------|
| **S3** | **Active (Recommended)** | `s3.hippius.com` |
| **IPFS** | Deprecated public node | Requires self-hosted IPFS node |

## Storage Options

### S3-Compatible Storage (Recommended)

**What it is:**
Secure object storage with full S3 API compatibility, using decentralized storage volumes as the backend.

**How it works:**
- Files stored in buckets using familiar S3 API
- Backend uses decentralized storage infrastructure (Bittensor SN75)
- Rapid access through HTTPS API endpoints
- Supports standard S3 operations (PUT, GET, DELETE, LIST)
- Compatible with aws-cli, boto3, MinIO client, and any S3 SDK

**Best for:**
- All general-purpose storage needs
- Private files requiring access control
- Applications already using S3 APIs
- Frequent file updates and modifications
- Large datasets requiring fast random access
- Agent state persistence and backups

**Configuration:**
- Endpoint: `https://s3.hippius.com`
- Region: `decentralized`
- Auth: Access keys from console.hippius.com (prefix: `hip_`)

### IPFS Storage (Advanced)

**What it is:**
Fully decentralized, content-addressed storage where the blockchain manages file pinning.

**Current limitation:**
The public IPFS node (`store.hippius.network`) has been deprecated. To use IPFS storage, you must run your own IPFS node and configure the `hippius` CLI to point at it.

**Best for:**
- Public data that should be permanently content-addressed
- CID-based referencing (same content = same hash)
- Integration with IPFS ecosystem tooling

**Requirements:**
- Self-hosted IPFS node (e.g., `ipfs daemon` on port 5001)
- `hippius` Python CLI configured with `ipfs.api_url`

## Using S3-Compatible Storage

### Authentication

Get credentials from [console.hippius.com](https://console.hippius.com/dashboard/settings):
- **Access Key ID**: Starts with `hip_` prefix
- **Secret Access Key**: Standard secret key
- Two types: Main keys (full access) and Sub keys (scoped with ACL)

### Via AWS CLI

```bash
# Set credentials
export AWS_ACCESS_KEY_ID="hip_your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"

# Create bucket
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 mb s3://my-bucket

# Upload a file
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 cp local_file.txt s3://my-bucket/remote_file.txt

# Download a file
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 cp s3://my-bucket/remote_file.txt local_file.txt

# List files
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 ls s3://my-bucket/

# List recursively
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 ls s3://my-bucket/ --recursive

# Sync directory
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 sync ./local-dir/ s3://my-bucket/remote-dir/

# Delete file
aws --endpoint-url https://s3.hippius.com --region decentralized \
    s3 rm s3://my-bucket/file.txt
```

### Via Python (boto3)

```python
import boto3

s3 = boto3.client(
    's3',
    endpoint_url='https://s3.hippius.com',
    aws_access_key_id='hip_your_access_key',
    aws_secret_access_key='your_secret_key',
    region_name='decentralized'
)

# Upload
s3.upload_file('local_file.txt', 'my-bucket', 'remote_file.txt')

# Download
s3.download_file('my-bucket', 'remote_file.txt', 'downloaded_file.txt')

# List objects
response = s3.list_objects_v2(Bucket='my-bucket')
for obj in response.get('Contents', []):
    print(f"{obj['Key']} ({obj['Size']} bytes)")

# Create bucket
s3.create_bucket(Bucket='my-new-bucket')
```

### Via Python (MinIO)

```python
from minio import Minio

client = Minio(
    "s3.hippius.com",
    access_key="hip_your_access_key",
    secret_key="your_secret_key",
    secure=True,
    region="decentralized"
)

# Upload
client.fput_object("my-bucket", "file.txt", "/path/to/file.txt")

# Download
client.fget_object("my-bucket", "file.txt", "/path/to/downloaded.txt")

# List objects
for obj in client.list_objects("my-bucket", recursive=True):
    print(f"{obj.object_name} ({obj.size} bytes)")
```

### Via JavaScript (MinIO)

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

// Upload
await client.fPutObject('my-bucket', 'file.txt', '/path/to/file.txt');

// Download
await client.fGetObject('my-bucket', 'file.txt', '/path/to/downloaded.txt');

// List objects
const stream = client.listObjects('my-bucket', '', true);
stream.on('data', (obj) => console.log(obj.name, obj.size));
```

## Using IPFS Storage (Advanced)

### Setup Required

1. Install and run IPFS daemon:
   ```bash
   # Install IPFS (e.g., via Homebrew)
   brew install ipfs
   ipfs init
   ipfs daemon
   ```

2. Configure hippius CLI:
   ```bash
   pip install hippius
   hippius config set ipfs api_url http://localhost:5001
   hippius config set ipfs local_ipfs true
   ```

### Operations (with IPFS node running)

```bash
# Upload file
hippius store /path/to/file.txt --no-encrypt

# Download by CID
hippius download QmYourCID /path/to/output.txt

# Pin a CID
hippius pin QmYourCID

# List files
hippius files

# Check if CID exists
hippius exists QmYourCID
```

## Storage Comparison

| Feature | S3 Storage | IPFS Storage |
|---------|-----------|--------------|
| **Status** | Active (recommended) | Requires self-hosted node |
| **Setup** | Credentials only | IPFS daemon + CLI config |
| **Privacy** | Private with access control | Public by default |
| **Addressing** | Key-based (bucket/key) | Content-addressed (CID) |
| **Mutability** | Mutable (update in place) | Immutable (new CID per change) |
| **Speed** | Fast (API-based) | Variable (distributed) |
| **API** | S3-compatible (aws-cli, boto3) | hippius CLI |
| **Region** | `decentralized` | N/A |

## Best Practices

### For S3 Storage

1. **Use `decentralized` region** - not `us-east-1` or any AWS region
2. **Secure credentials** - use environment variables, not hardcoded values
3. **Organize with prefixes** - use key prefixes like folders (e.g., `snapshots/`, `files/`)
4. **Keep a `latest` alias** - for state backups, copy to a known key like `latest.tar.gz`
5. **Monitor usage** - track stored objects and sizes

### General

1. **Backup important data** - don't rely on a single storage solution
2. **Keep credentials secure** - protect API keys and mnemonics
3. **Test round-trips** - verify you can upload AND download successfully
4. **Use `.env` files** - with `chmod 600` permissions

## Troubleshooting

### S3 Access Errors

- Verify access key starts with `hip_`
- Region must be `decentralized` (not `us-east-1`)
- Endpoint must be `https://s3.hippius.com`
- Check keys at console.hippius.com > Settings > API Keys

### "Public store.hippius.network has been deprecated"

Use S3 instead, or set up a local IPFS node:
```bash
hippius config set ipfs api_url http://localhost:5001
hippius config set ipfs local_ipfs true
```

### Slow Uploads

- Check network connection
- For large files (>5MB), S3 handles multipart uploads automatically
- Try at different times if network congestion is an issue

## Resources

- **Hippius Docs**: [docs.hippius.com](https://docs.hippius.com)
- **S3 Integration**: [docs.hippius.com/storage/s3/integration](https://docs.hippius.com/storage/s3/integration)
- **Console**: [console.hippius.com](https://console.hippius.com)
