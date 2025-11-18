# Hippius Authentication Guide

## Overview

Hippius uses mnemonic-based authentication that provides secure access without requiring browser extensions or storing sensitive data on servers. Your mnemonic phrase serves as both your identity and encryption key.

## Critical Security Warning

⚠️ **IMPORTANT**: There is **no 'forgot password' option** in Hippius. Neither support teams nor any other party can recover lost access keys. If you lose your mnemonic phrase, you permanently lose access to your account and all associated data.

**Always:**
- Write down your mnemonic phrase on paper
- Store it in a secure location (safe, safety deposit box)
- Never share it with anyone
- Never store it in plain text on your computer
- Consider using a hardware wallet for high-value accounts
- Make multiple secure backups in different physical locations

## Mnemonic Phrases

### What is a Mnemonic Phrase?

A mnemonic phrase (also called a seed phrase) is a series of 12 or 24 words that represents your private key in human-readable form.

**Example format** (DO NOT USE THIS):
```
witch collapse practice feed shame open despair creek road again ice least
```

### Generating a Mnemonic

#### Via Hippius Console

1. Navigate to [console.hippius.com](https://console.hippius.com)
2. Click "Create New Account"
3. The system generates a random 12 or 24-word mnemonic
4. **Write it down immediately** and store it securely
5. Verify the mnemonic by entering it again

#### Via CLI

The Hippius CLI can generate a new wallet:

```bash
hipc wallet create
```

This generates:
- A new mnemonic phrase
- Associated public address
- Key files for node operations

**CRITICAL**: The mnemonic is displayed only once. Write it down immediately.

#### Via External Tools

You can use standard Substrate/Polkadot tools:

- **Subkey**: Official Substrate key generation tool
- **Polkadot.js Extension**: Browser extension for Substrate chains
- **Hardware wallets**: Ledger devices with Substrate support

### Importing an Existing Mnemonic

If you already have a mnemonic from another Substrate-based chain, you can import it to Hippius.

**Via Console:**
1. Go to [console.hippius.com](https://console.hippius.com)
2. Click "Import Account"
3. Enter your mnemonic phrase
4. Access your account

**Via CLI:**
Set the environment variable:
```bash
export SUBSTRATE_SEED_PHRASE="your twelve or twenty-four word mnemonic phrase here"
```

Or add to `.env` file:
```
SUBSTRATE_SEED_PHRASE="your twelve or twenty-four word mnemonic phrase here"
```

## Environment Configuration

### For Hippius CLI

The CLI requires two environment variables:

#### SUBSTRATE_NODE_URL

The WebSocket endpoint for the Hippius blockchain node.

**Default**: `ws://127.0.0.1:9944` (local node)

**Public node** (if available):
```bash
export SUBSTRATE_NODE_URL="wss://rpc.hippius.com"
```

#### SUBSTRATE_SEED_PHRASE

Your 12 or 24-word mnemonic phrase.

**Setting via environment:**
```bash
export SUBSTRATE_SEED_PHRASE="your twelve or twenty-four word mnemonic phrase here"
```

**Setting via .env file:**

Create a `.env` file in your project directory:
```
SUBSTRATE_NODE_URL=wss://rpc.hippius.com
SUBSTRATE_SEED_PHRASE="your twelve or twenty-four word mnemonic phrase here"
```

**Loading .env file:**
```bash
source .env
```

Or use the CLI to load automatically:
```bash
source ~/.claude/.env
```

### For S3-Compatible Storage

S3 operations require separate access credentials.

#### Obtaining S3 Credentials

1. Log in to [console.hippius.com](https://console.hippius.com)
2. Navigate to Settings > API Keys
3. Click "Generate New Key"
4. Save your Access Key ID and Secret Access Key immediately
   - Access Key ID: `HIPPIUS_ACCESS_KEY_XXXXX`
   - Secret Access Key: `HIPPIUS_SECRET_XXXXXXXXXXXXX`

#### Configuring AWS SDK

**Python (boto3):**
```python
import boto3

s3_client = boto3.client(
    's3',
    endpoint_url='https://s3.hippius.com',
    aws_access_key_id='HIPPIUS_ACCESS_KEY_XXXXX',
    aws_secret_access_key='HIPPIUS_SECRET_XXXXXXXXXXXXX'
)
```

**AWS CLI:**
```bash
aws configure --profile hippius
# AWS Access Key ID: HIPPIUS_ACCESS_KEY_XXXXX
# AWS Secret Access Key: HIPPIUS_SECRET_XXXXXXXXXXXXX
# Default region name: us-east-1
# Default output format: json
```

**Environment variables:**
```bash
export AWS_ACCESS_KEY_ID="HIPPIUS_ACCESS_KEY_XXXXX"
export AWS_SECRET_ACCESS_KEY="HIPPIUS_SECRET_XXXXXXXXXXXXX"
export AWS_ENDPOINT_URL="https://s3.hippius.com"
```

## Account Derivation

Hippius uses standard Substrate account derivation:

1. **Mnemonic phrase** → Seed (512 bits)
2. **Seed** → Private key (Ed25519 or Sr25519)
3. **Private key** → Public key
4. **Public key** → Account address (SS58 format)

### Address Format

Hippius uses SS58 address encoding with a specific network prefix.

**Example address format:**
```
5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY
```

**Address properties:**
- Case-sensitive
- Starts with network-specific prefix
- Contains checksum for error detection
- Derived from your public key

## Security Best Practices

### Protecting Your Mnemonic

1. **Never share**: Don't give your mnemonic to anyone, including support staff
2. **Offline storage**: Write on paper, never store digitally
3. **Multiple backups**: Store copies in different secure locations
4. **Metal backups**: Consider fireproof/waterproof metal seed phrase storage
5. **No photos**: Don't take pictures of your seed phrase
6. **No cloud storage**: Never store in Dropbox, Google Drive, etc.
7. **Verify backups**: Test your backup by recovering to ensure accuracy

### Operational Security

1. **Use hardware wallets** for high-value accounts
2. **Separate hot/cold wallets**: Keep most funds in cold storage
3. **Test with small amounts** before large transactions
4. **Verify addresses** character-by-character before sending
5. **Use secure networks**: Avoid public WiFi for account access
6. **Keep software updated**: Update CLI and node software regularly
7. **Monitor account activity**: Regularly check for unauthorized transactions

### Environment Variable Security

1. **File permissions**: Protect `.env` files
   ```bash
   chmod 600 .env
   ```

2. **Don't commit**: Add `.env` to `.gitignore`
   ```
   .env
   .env.local
   ```

3. **Use secrets management**: Consider tools like:
   - HashiCorp Vault
   - AWS Secrets Manager
   - 1Password CLI
   - Environment variable encryption

4. **Limit exposure**: Unset environment variables when done
   ```bash
   unset SUBSTRATE_SEED_PHRASE
   ```

## Account Recovery

### If You Have Your Mnemonic

Recovery is straightforward if you have your mnemonic:

1. Import mnemonic via console or CLI
2. Your account address and balance are restored automatically
3. Access to all files and services is restored

### If You Lost Your Mnemonic

**There is no recovery option.** Your account is permanently inaccessible.

**Prevention is the only solution:**
- Multiple secure backups
- Regular verification of backups
- Secure physical storage
- Consider multi-signature accounts for organizations

## Multi-Signature Accounts

For organizational use, consider multi-signature (multisig) accounts:

**Benefits:**
- Require multiple parties to authorize transactions
- Reduces single point of failure
- Shared responsibility for account security
- Audit trail of authorization

**Setup** (via Polkadot.js or similar tools):
1. Create multisig account with required signers
2. Set threshold (e.g., 2-of-3 signatures required)
3. Distribute signing responsibility among trusted parties

## Troubleshooting

### Authentication Failed

**Problem**: CLI or console rejects mnemonic

**Solutions:**
- Verify mnemonic spelling and word order
- Check for extra spaces or special characters
- Ensure using correct derivation path
- Try importing to Polkadot.js extension to verify validity

### Wrong Account Address

**Problem**: Imported mnemonic shows different address

**Solutions:**
- Verify network/chain ID matches Hippius
- Check derivation path (should be standard Substrate path)
- Ensure no custom password/passphrase was used
- Verify SS58 address format for Hippius network

### S3 Access Denied

**Problem**: S3 operations fail with authentication error

**Solutions:**
- Verify Access Key ID and Secret Key
- Check endpoint URL is correct
- Ensure keys haven't been revoked in console
- Verify account has sufficient credits
- Check bucket permissions

## Resources

- **Hippius Console**: [console.hippius.com](https://console.hippius.com)
- **Substrate Key Management**: [docs.substrate.io/reference/command-line-tools/subkey](https://docs.substrate.io/reference/command-line-tools/subkey/)
- **Polkadot.js Extension**: Chrome/Firefox extension for Substrate chains
- **Hippius Community**: [community.hippius.com](https://community.hippius.com)
- **Security Best Practices**: [docs.hippius.com/learn/security](https://docs.hippius.com/learn/security)
