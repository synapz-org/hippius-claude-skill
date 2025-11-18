# Hippius Blockchain RPC API Reference

## Overview

The Hippius API provides RPC methods for interacting with a Substrate-based blockchain, enabling queries on node metrics, rewards, storage, and account information.

## Base Endpoint

- API URL: `http://api.hippius.io`
- Swagger UI: `http://api.hippius.io/swagger-ui`

## Response Format

All endpoints return JSON-RPC 2.0 format with `jsonrpc`, `result`, and `id` fields.

## RPC Methods

### Node & Metrics Operations

#### get_active_nodes_metrics_by_type

Retrieves detailed metrics for active nodes of a specified node type.

**Supported node types:**
- Validator
- StorageMiner
- StorageS3
- ComputeMiner
- GpuMiner

**Returns:**
- Miner ID
- Bandwidth metrics
- Storage metrics
- Geolocation data
- Performance indicators

### Reward Queries

#### get_total_node_rewards

Aggregates rewards across all node types for a specific account.

**Parameters:**
- `account_id` (string): The account address

**Returns:**
- Total rewards earned across all node types

#### get_total_distributed_rewards_by_node_type

Total payouts by node classification.

**Parameters:**
- `node_type` (string): Validator, StorageMiner, StorageS3, ComputeMiner, or GpuMiner

**Returns:**
- Total distributed rewards for the specified node type

#### get_account_pending_rewards

Unclaimed rewards for specific accounts.

**Parameters:**
- `account_id` (string): The account address

**Returns:**
- Pending (unclaimed) rewards

#### get_miners_total_rewards

Cumulative earnings by miner type.

**Parameters:**
- `miner_type` (string): The type of miner

**Returns:**
- Total rewards earned by miners of the specified type

### Storage Management

#### get_user_files

Returns file information for a user account.

**Parameters:**
- `account_id` (string): The account address

**Returns:**
- File hashes
- File names
- File sizes
- Pinning miner IDs

#### get_user_buckets

Lists bucket information for a user account.

**Parameters:**
- `account_id` (string): The account address

**Returns:**
- Bucket names
- Associated size vectors

#### calculate_total_file_size

Calculates the total file size for all approved and pinned files.

**Parameters:**
- `account_id` (string): The account address

**Returns:**
- Total file size in bytes

#### get_bucket_size

Individual bucket capacity query.

**Parameters:**
- `account_id` (string): The account address
- `bucket_name` (string): The bucket name

**Returns:**
- Bucket size in bytes

### Account & Network Data

#### get_user_vms

VM deployment information.

**Parameters:**
- `account_id` (string): The account address

**Returns:**
- VM status ("Running," "Failed," "Pending")
- Hypervisor details
- VNC ports

#### get_client_ip

Client IP address lookup.

**Parameters:**
- `account_id` (string): The account address

**Returns:**
- Client IP address

#### get_vm_ip

Virtual machine IP address lookup.

**Parameters:**
- `vm_id` (string): The VM identifier

**Returns:**
- VM IP address

#### get_storage_miner_ip

Storage miner IP address lookup.

**Parameters:**
- `miner_id` (string): The miner identifier

**Returns:**
- Storage miner IP address

#### get_free_credits_rpc

Account credit balances.

**Parameters:**
- `account_id` (string): The account address

**Returns:**
- Free credit balance

#### get_referral_rewards

Earned through referral program participation.

**Parameters:**
- `account_id` (string): The account address

**Returns:**
- Referral rewards earned

### Batch Operations

#### get_batches_for_user

Lists credit/alpha allocations with freeze status.

**Parameters:**
- `account_id` (string): The account address

**Returns:**
- List of batches with freeze status

#### get_batch_by_id

Retrieves specific batch details by identifier.

**Parameters:**
- `batch_id` (string): The batch identifier

**Returns:**
- Batch details including allocation and freeze status

## Authentication

The documentation does not specify authentication requirements for RPC endpoint access. Consult the official documentation or community resources for current authentication methods.

## Error Handling

Standard JSON-RPC 2.0 error responses are returned when requests fail.

## Rate Limits

Rate limit information is not specified in the available documentation. Monitor API responses for rate limit headers or consult official documentation.
