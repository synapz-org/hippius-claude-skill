# Hippius Storage Guide

## Overview

Hippius offers two primary storage solutions: IPFS-based decentralized storage and S3-compatible hybrid storage. This guide helps you choose the right option and use it effectively.

## Storage Options

### IPFS Storage

**What it is:**
Fully decentralized, content-addressed storage where the blockchain manages file pinning.

**How it works:**
- Files are stored across a distributed network of IPFS nodes
- Each file receives a unique Content Identifier (CID) based on its content
- The Hippius blockchain tracks which miners are pinning your files
- Content is permanent and immutable once pinned

**Best for:**
- Public data that should be permanently available
- Content that benefits from deduplication
- Files that need to be shared across the decentralized web
- NFT metadata and assets
- Websites and web applications
- Documentation and public datasets

**Advantages:**
- Truly decentralized and censorship-resistant
- Content-addressed (same content = same hash)
- No single point of failure
- Transparent on-chain tracking of pinning
- Permanent storage with proper pinning

**Limitations:**
- Generally slower retrieval for first access (caching improves this)
- All content is public and discoverable by CID
- Cannot modify files (must upload new version with new CID)
- Costs associated with pinning across multiple nodes

### S3-Compatible Storage

**What it is:**
Secure object storage with S3-compatible API, using decentralized storage volumes as the backend.

**How it works:**
- Files stored in buckets using familiar S3 API
- Backend uses decentralized storage infrastructure
- Rapid access through API endpoints
- Supports standard S3 operations (PUT, GET, DELETE, LIST)

**Best for:**
- Private files requiring access control
- Applications already using S3 APIs
- Frequent file updates and modifications
- Large datasets requiring fast random access
- Application backends needing object storage
- Files requiring encryption and privacy

**Advantages:**
- Fast access with API-based retrieval
- Familiar S3 API for easy integration
- Private storage with access controls
- Supports file modification and deletion
- Compatible with existing S3 tools and libraries

**Limitations:**
- Less decentralized than pure IPFS
- Requires trust in storage provider infrastructure
- May have single points of failure depending on configuration

## Storage Comparison

| Feature | IPFS Storage | S3-Compatible Storage |
|---------|--------------|----------------------|
| **Decentralization** | Fully decentralized | Hybrid (decentralized backend) |
| **Privacy** | Public by default | Private with access control |
| **Content Addressing** | Yes (CID-based) | No (key-based) |
| **Mutability** | Immutable (new CID per change) | Mutable (update in place) |
| **Speed** | Moderate (distributed) | Fast (API-based) |
| **API** | IPFS CLI/HTTP API | S3-compatible API |
| **Use Case** | Public permanent content | Private dynamic content |
| **Pricing Model** | Pay for pinning | Pay per use |

## Using IPFS Storage

### Via Hippius CLI

Pin a file to IPFS:
```bash
hipc storage pin /path/to/file.txt
```

Upload to IPFS:
```bash
hipc storage upload /path/to/file.txt
```

Unpin a file:
```bash
hipc storage unpin QmYourIPFSHashHere
```

### Via Console

1. Navigate to [console.hippius.com](https://console.hippius.com)
2. Log in with your mnemonic phrase
3. Go to Storage > IPFS
4. Click "Upload File" or "Pin to IPFS"
5. Select your file and confirm

### Retrieving IPFS Files

Access via public IPFS gateways:
```
https://ipfs.io/ipfs/<CID>
https://gateway.pinata.cloud/ipfs/<CID>
```

Or via local IPFS node:
```bash
ipfs cat <CID>
```

## Using S3-Compatible Storage

### Authentication

S3 operations require credentials. Obtain your access keys from the Hippius console.

### Via AWS SDK (Example: Python boto3)

```python
import boto3

# Configure S3 client for Hippius
s3_client = boto3.client(
    's3',
    endpoint_url='https://s3.hippius.com',
    aws_access_key_id='YOUR_ACCESS_KEY',
    aws_secret_access_key='YOUR_SECRET_KEY'
)

# Upload a file
s3_client.upload_file('local_file.txt', 'my-bucket', 'remote_file.txt')

# Download a file
s3_client.download_file('my-bucket', 'remote_file.txt', 'downloaded_file.txt')

# List objects in bucket
response = s3_client.list_objects_v2(Bucket='my-bucket')
for obj in response.get('Contents', []):
    print(obj['Key'])
```

### Via AWS CLI

Configure AWS CLI:
```bash
aws configure --profile hippius
# Enter your access key ID and secret key
# Set region to 'us-east-1' (or as specified)
# Set output format to 'json'
```

Upload a file:
```bash
aws s3 cp local_file.txt s3://my-bucket/remote_file.txt --profile hippius --endpoint-url https://s3.hippius.com
```

List files:
```bash
aws s3 ls s3://my-bucket/ --profile hippius --endpoint-url https://s3.hippius.com
```

Download a file:
```bash
aws s3 cp s3://my-bucket/remote_file.txt local_file.txt --profile hippius --endpoint-url https://s3.hippius.com
```

## Querying Storage via API

Check your files via RPC:
```bash
curl -X POST http://api.hippius.io \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "get_user_files",
    "params": ["YOUR_ACCOUNT_ADDRESS"],
    "id": 1
  }'
```

Check total storage used:
```bash
curl -X POST http://api.hippius.io \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "calculate_total_file_size",
    "params": ["YOUR_ACCOUNT_ADDRESS"],
    "id": 1
  }'
```

## Best Practices

### For IPFS Storage

1. **Pin important content**: Ensure your files are pinned to prevent garbage collection
2. **Use descriptive filenames**: Makes files easier to identify on-chain
3. **Consider file size**: Larger files take longer to distribute across the network
4. **Verify uploads**: Always verify the CID after uploading
5. **Keep CIDs safe**: Store CIDs securely; they're your only reference to content

### For S3 Storage

1. **Use bucket policies**: Implement appropriate access controls
2. **Enable versioning**: Protect against accidental deletions
3. **Monitor usage**: Track storage costs via blockchain records
4. **Use lifecycle policies**: Automatically clean up old data
5. **Encrypt sensitive data**: Use client-side encryption for sensitive files

### General

1. **Backup important data**: Don't rely on a single storage solution
2. **Monitor costs**: Track on-chain records of usage
3. **Test retrievals**: Regularly verify you can retrieve your files
4. **Use appropriate storage**: Match storage type to use case
5. **Keep credentials secure**: Protect mnemonic phrases and API keys

## Pricing

Hippius uses a pay-per-use model tracked on the blockchain:

- **IPFS pinning**: Pay for the storage space and redundancy across miners
- **S3 storage**: Pay for storage capacity and data transfer
- **Credits system**: Purchase credits or earn through referrals
- **Transparent billing**: All charges recorded on-chain

Check your credits:
```bash
hipc credits check
```

Or via API:
```bash
curl -X POST http://api.hippius.io \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "get_free_credits_rpc",
    "params": ["YOUR_ACCOUNT_ADDRESS"],
    "id": 1
  }'
```

## Troubleshooting

### IPFS Upload Issues

**Problem**: Upload fails or times out
- Check network connectivity
- Verify file size isn't too large
- Ensure sufficient credits in account
- Try uploading to multiple gateways

**Problem**: File not accessible after upload
- Wait for pinning to propagate (can take several minutes)
- Verify CID is correct
- Check if enough miners have pinned the file
- Try accessing via different IPFS gateways

### S3 Access Issues

**Problem**: Authentication errors
- Verify access key and secret key
- Check endpoint URL is correct
- Ensure account has sufficient credits
- Verify bucket permissions

**Problem**: Slow uploads/downloads
- Check network connection
- Try different times (network congestion)
- Consider file size and chunking for large files
- Verify endpoint region settings

## Resources

- **Hippius Documentation**: [docs.hippius.com](https://docs.hippius.com)
- **IPFS Documentation**: [docs.ipfs.tech](https://docs.ipfs.tech)
- **AWS S3 Documentation**: [docs.aws.amazon.com/s3](https://docs.aws.amazon.com/s3/)
- **Hippius Community**: [community.hippius.com](https://community.hippius.com)
- **API Reference**: See `api_reference.md`
- **CLI Commands**: See `cli_commands.md`
