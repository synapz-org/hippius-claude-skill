#!/usr/bin/env python3
"""
Hippius Storage Query Script

This script queries the Hippius blockchain RPC API to retrieve
storage information for a user account.
"""

import json
import sys
import argparse
from typing import Dict, Any, Optional
from urllib.request import Request, urlopen
from urllib.error import HTTPError, URLError


# ANSI color codes
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'  # No Color


def print_error(message: str) -> None:
    """Print error message in red."""
    print(f"{Colors.RED}ERROR: {message}{Colors.NC}", file=sys.stderr)


def print_success(message: str) -> None:
    """Print success message in green."""
    print(f"{Colors.GREEN}✓ {message}{Colors.NC}")


def print_warning(message: str) -> None:
    """Print warning message in yellow."""
    print(f"{Colors.YELLOW}⚠ {message}{Colors.NC}")


def print_info(message: str) -> None:
    """Print info message in blue."""
    print(f"{Colors.BLUE}ℹ {message}{Colors.NC}")


def rpc_call(method: str, params: list, api_url: str = "http://api.hippius.io") -> Optional[Dict[str, Any]]:
    """
    Make an RPC call to the Hippius API.

    Args:
        method: RPC method name
        params: List of parameters
        api_url: API endpoint URL

    Returns:
        Response data or None on error
    """
    payload = {
        "jsonrpc": "2.0",
        "method": method,
        "params": params,
        "id": 1
    }

    headers = {
        "Content-Type": "application/json"
    }

    try:
        request = Request(
            api_url,
            data=json.dumps(payload).encode('utf-8'),
            headers=headers
        )

        with urlopen(request) as response:
            data = json.loads(response.read().decode('utf-8'))

            if "error" in data:
                print_error(f"RPC Error: {data['error']}")
                return None

            return data.get("result")

    except HTTPError as e:
        print_error(f"HTTP Error: {e.code} - {e.reason}")
        return None
    except URLError as e:
        print_error(f"Connection Error: {e.reason}")
        return None
    except json.JSONDecodeError:
        print_error("Failed to parse API response")
        return None
    except Exception as e:
        print_error(f"Unexpected error: {str(e)}")
        return None


def format_bytes(bytes_value: int) -> str:
    """Format bytes into human-readable format."""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes_value < 1024.0:
            return f"{bytes_value:.2f} {unit}"
        bytes_value /= 1024.0
    return f"{bytes_value:.2f} PB"


def query_user_files(account_id: str) -> None:
    """Query and display user files."""
    print_info(f"Querying files for account: {account_id}")
    print()

    result = rpc_call("get_user_files", [account_id])

    if result is None:
        print_error("Failed to retrieve user files")
        return

    if not result or len(result) == 0:
        print_warning("No files found for this account")
        return

    print("=" * 80)
    print("  User Files")
    print("=" * 80)
    print()

    for idx, file_info in enumerate(result, 1):
        print(f"File #{idx}")
        print(f"  Hash: {file_info.get('hash', 'N/A')}")
        print(f"  Name: {file_info.get('name', 'N/A')}")
        print(f"  Size: {format_bytes(file_info.get('size', 0))}")
        print(f"  Pinning Miners: {', '.join(file_info.get('miners', [])) if file_info.get('miners') else 'None'}")
        print()

    print_success(f"Total files: {len(result)}")


def query_total_storage(account_id: str) -> None:
    """Query and display total storage used."""
    print_info(f"Querying total storage for account: {account_id}")
    print()

    result = rpc_call("calculate_total_file_size", [account_id])

    if result is None:
        print_error("Failed to retrieve total storage")
        return

    print("=" * 80)
    print("  Total Storage Used")
    print("=" * 80)
    print()

    total_bytes = int(result)
    print(f"  Total: {format_bytes(total_bytes)} ({total_bytes:,} bytes)")
    print()

    print_success("Storage query complete")


def query_user_buckets(account_id: str) -> None:
    """Query and display user buckets."""
    print_info(f"Querying buckets for account: {account_id}")
    print()

    result = rpc_call("get_user_buckets", [account_id])

    if result is None:
        print_error("Failed to retrieve user buckets")
        return

    if not result or len(result) == 0:
        print_warning("No buckets found for this account")
        return

    print("=" * 80)
    print("  User Buckets")
    print("=" * 80)
    print()

    for idx, bucket_info in enumerate(result, 1):
        bucket_name = bucket_info.get('name', 'N/A')
        bucket_sizes = bucket_info.get('sizes', [])
        total_size = sum(bucket_sizes) if bucket_sizes else 0

        print(f"Bucket #{idx}")
        print(f"  Name: {bucket_name}")
        print(f"  Size: {format_bytes(total_size)}")
        print()

    print_success(f"Total buckets: {len(result)}")


def query_account_credits(account_id: str) -> None:
    """Query and display account credits."""
    print_info(f"Querying credits for account: {account_id}")
    print()

    result = rpc_call("get_free_credits_rpc", [account_id])

    if result is None:
        print_error("Failed to retrieve account credits")
        return

    print("=" * 80)
    print("  Account Credits")
    print("=" * 80)
    print()

    credits = float(result) if result else 0.0
    print(f"  Free Credits: {credits:.4f}")
    print()

    if credits < 1.0:
        print_warning("Low credit balance - consider adding credits")
    else:
        print_success("Credit balance is healthy")


def query_all(account_id: str) -> None:
    """Query and display all account information."""
    print()
    print("=" * 80)
    print("  Hippius Storage Account Summary")
    print("=" * 80)
    print()

    # Query files
    query_user_files(account_id)
    print()

    # Query total storage
    query_total_storage(account_id)
    print()

    # Query buckets
    query_user_buckets(account_id)
    print()

    # Query credits
    query_account_credits(account_id)
    print()


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Query Hippius storage information for an account",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Query all information
  %(prog)s 5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY

  # Query only files
  %(prog)s 5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY --files

  # Query only storage size
  %(prog)s 5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY --storage

  # Query only buckets
  %(prog)s 5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY --buckets

  # Query only credits
  %(prog)s 5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY --credits
        """
    )

    parser.add_argument(
        "account_id",
        help="Hippius account address (SS58 format)"
    )

    parser.add_argument(
        "--files",
        action="store_true",
        help="Query user files"
    )

    parser.add_argument(
        "--storage",
        action="store_true",
        help="Query total storage used"
    )

    parser.add_argument(
        "--buckets",
        action="store_true",
        help="Query user buckets"
    )

    parser.add_argument(
        "--credits",
        action="store_true",
        help="Query account credits"
    )

    parser.add_argument(
        "--api-url",
        default="http://api.hippius.io",
        help="Hippius API URL (default: http://api.hippius.io)"
    )

    args = parser.parse_args()

    # If no specific query flags are set, query everything
    if not (args.files or args.storage or args.buckets or args.credits):
        query_all(args.account_id)
        return

    # Query specific information based on flags
    if args.files:
        query_user_files(args.account_id)
        print()

    if args.storage:
        query_total_storage(args.account_id)
        print()

    if args.buckets:
        query_user_buckets(args.account_id)
        print()

    if args.credits:
        query_account_credits(args.account_id)
        print()


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print()
        print_warning("Operation cancelled by user")
        sys.exit(130)
    except Exception as e:
        print_error(f"Unexpected error: {str(e)}")
        sys.exit(1)
