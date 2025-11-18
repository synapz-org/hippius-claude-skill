# Hippius CLI Commands Reference

## Overview

The Hippius CLI (`hipc`) is a Rust-based command-line tool for IPFS and S3 storage, referral, and node operations on the Hippius blockchain.

## Installation

### Prerequisites

1. **Rust**: Install from [rust-lang.org/tools/install](https://www.rust-lang.org/tools/install)
2. **Docker**: Install from [docs.docker.com/get-docker](https://docs.docker.com/get-docker/)
3. **Running Substrate node** with required modules
4. **Environment variables**:
   - `SUBSTRATE_NODE_URL` (default: `ws://127.0.0.1:9944`)
   - `SUBSTRATE_SEED_PHRASE`

### Installation Steps

```bash
# Clone the repository
git clone https://github.com/thenervelab/hipc.git
cd hipc

# Build and install
cargo install --path .

# Copy binary to system path
cp target/release/hipc /usr/local/bin/
```

### Configuration

Create a `.env` file in your project directory or set environment variables:

```bash
SUBSTRATE_NODE_URL=ws://127.0.0.1:9944
SUBSTRATE_SEED_PHRASE="your twelve or twenty-four word mnemonic phrase here"
```

## Command Categories

### Wallet Management

#### Create New Hotkey Wallet

Create a new hotkey wallet for use with Hippius.

```bash
hipc wallet create
```

#### List Available Wallets

Display all wallets available to the CLI.

```bash
hipc wallet list
```

### Storage Operations

#### Pin File to IPFS

Upload and pin a file to decentralized IPFS storage.

```bash
hipc storage pin <file_path>
```

**Parameters:**
- `file_path`: Path to the file to pin

**Returns:**
- IPFS hash (CID) of the pinned file

#### Unpin File from IPFS

Remove a file from IPFS pinning.

```bash
hipc storage unpin <ipfs_hash>
```

**Parameters:**
- `ipfs_hash`: The IPFS CID of the file to unpin

#### Upload File to IPFS

Upload a file to IPFS storage.

```bash
hipc storage upload <file_path>
```

**Parameters:**
- `file_path`: Path to the file to upload

**Returns:**
- IPFS hash (CID) of the uploaded file

### Node Management

#### Register Validator Node

Register a validator node on the Hippius network.

**With hotkey:**
```bash
hipc node register-validator --hotkey <hotkey_address>
```

**With coldkey:**
```bash
hipc node register-validator --coldkey <coldkey_address>
```

**Parameters:**
- `--hotkey`: Hotkey wallet address
- `--coldkey`: Coldkey wallet address

#### Register Storage Miner Node

Register a storage miner node on the Hippius network.

```bash
hipc node register-storage-miner
```

#### Query Node Information

Retrieve information about a specific node.

```bash
hipc node info <node_id>
```

**Parameters:**
- `node_id`: The identifier of the node

**Returns:**
- Node type
- Status
- Performance metrics
- Registration details

#### Swap Node Ownership

Transfer ownership of a node to another account.

```bash
hipc node swap <node_id> <new_owner_address>
```

**Parameters:**
- `node_id`: The identifier of the node
- `new_owner_address`: The address of the new owner

### Account Operations

#### Transfer Funds

Transfer funds between accounts.

```bash
hipc account transfer <recipient_address> <amount>
```

**Parameters:**
- `recipient_address`: The address to send funds to
- `amount`: Amount to transfer

#### Stake Funds

Stake funds to participate in network consensus.

```bash
hipc account stake <amount>
```

**Parameters:**
- `amount`: Amount to stake

#### Unstake Funds

Unstake previously staked funds.

```bash
hipc account unstake <amount>
```

**Parameters:**
- `amount`: Amount to unstake

#### Withdraw Funds

Withdraw funds from your account.

```bash
hipc account withdraw <amount>
```

**Parameters:**
- `amount`: Amount to withdraw

### Additional Tools

#### Check Account Credits

Retrieve the free credit balance for your account.

```bash
hipc credits check
```

**Returns:**
- Free credit balance

#### Retrieve HIPS Key Files

Obtain HIPS key files for your account.

```bash
hipc keys get-hips
```

#### Obtain IPFS ID

Get the IPFS ID for your node.

```bash
hipc ipfs get-id
```

**Returns:**
- IPFS peer ID

#### Obtain Node ID

Get the node ID for your registered node.

```bash
hipc node get-id
```

**Returns:**
- Node identifier

#### Insert Keys to Local Node

Insert cryptographic keys to a local Substrate node.

```bash
hipc keys insert <key_type> <key_value>
```

**Parameters:**
- `key_type`: Type of key (e.g., aura, gran)
- `key_value`: The key value to insert

## Troubleshooting

### Connection Issues

If you encounter connection issues:

1. Verify `SUBSTRATE_NODE_URL` is set correctly
2. Ensure the Substrate node is running and accessible
3. Check firewall settings

### Authentication Errors

If authentication fails:

1. Verify `SUBSTRATE_SEED_PHRASE` is set correctly
2. Ensure the mnemonic phrase is valid (12 or 24 words)
3. Check that the account has sufficient balance for transactions

### Docker Requirements

Some storage operations may require Docker. Ensure Docker is running:

```bash
docker ps
```

## License

The Hippius CLI is MIT licensed.
