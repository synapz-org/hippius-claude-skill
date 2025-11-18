# Hippius User - Claude Code Skill

A comprehensive Claude Code skill for interacting with Hippius, the decentralized cloud storage platform on Bittensor Subnet 75.

## Overview

This skill enables Claude to help users:
- Upload files to IPFS and S3-compatible storage via Hippius
- Query storage metrics, files, and account credits
- Set up and configure the Hippius CLI
- Manage authentication and security credentials
- Understand IPFS vs S3 storage options

## Features

### Automated Scripts
- **install_cli.sh** - One-command Hippius CLI installation with prerequisite checks
- **upload_to_ipfs.sh** - Convenient file upload wrapper with pinning support
- **query_storage.py** - Query files, buckets, storage usage, and credits

### Comprehensive Documentation
- **API Reference** - Complete RPC API documentation (26+ methods)
- **CLI Commands** - Full command reference with examples
- **Storage Guide** - IPFS vs S3 comparison and best practices
- **Authentication Guide** - Security, mnemonic management, and credentials setup

### Quick Start Templates
- **.env.template** - Pre-configured environment setup template

## Installation

### For Claude Code Users

1. Download the skill package (`hippius-user.zip`)
2. Extract to your Claude Code skills directory:
   ```bash
   unzip hippius-user.zip -d ~/.claude/skills/
   ```
3. Restart Claude Code or reload skills

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/hippius-claude-skill.git
   cd hippius-claude-skill/hippius-user
   ```

2. Copy to your Claude Code skills directory:
   ```bash
   cp -r . ~/.claude/skills/hippius-user/
   ```

## Usage

Once installed, the skill activates automatically when you:
- Ask Claude to upload files to Hippius
- Request information about Hippius storage
- Need to set up the Hippius CLI
- Want to check your storage status or credits

### Example Requests

```
"Upload this PDF to Hippius"
"Set up Hippius CLI for me"
"What files do I have stored on Hippius?"
"How much storage am I using?"
"What's the difference between IPFS and S3 on Hippius?"
"Check my Hippius credit balance"
```

## Skill Contents

```
hippius-user/
├── SKILL.md                        # Main skill instructions for Claude
├── README.md                       # This file
├── scripts/                        # Automation scripts
│   ├── install_cli.sh             # CLI installation
│   ├── upload_to_ipfs.sh          # File upload wrapper
│   └── query_storage.py           # Storage query tool
├── references/                     # Detailed documentation
│   ├── api_reference.md           # RPC API docs
│   ├── cli_commands.md            # CLI reference
│   ├── storage_guide.md           # IPFS vs S3 guide
│   └── authentication.md          # Security guide
└── assets/                         # Templates and resources
    └── .env.template              # Environment config template
```

## Prerequisites

For using the Hippius CLI (installed via this skill):
- **Rust** - [Install from rust-lang.org](https://rust-lang.org/tools/install)
- **Docker** - [Install from docs.docker.com](https://docs.docker.com/get-docker/)
- **Mnemonic seed phrase** - 12 or 24-word phrase for authentication

The skill's installation script checks and guides you through setup.

## About Hippius

Hippius is a decentralized cloud storage platform powered by:
- **Substrate blockchain** - Custom blockchain optimized for storage
- **IPFS** - Decentralized, content-addressed permanent storage
- **S3-Compatible Storage** - Familiar API with decentralized backend
- **Bittensor Network** - Subnet 75 on Bittensor

### Key Features
- Transparent, blockchain-tracked usage and billing
- Pay-per-use pricing model
- Dual storage options (IPFS and S3)
- Decentralized infrastructure with no single point of failure
- End-to-end encryption
- Referral rewards program

## External Resources

- **Hippius Documentation**: [docs.hippius.com](https://docs.hippius.com)
- **Hippius Console**: [console.hippius.com](https://console.hippius.com)
- **Hippius API**: [api.hippius.io](http://api.hippius.io)
- **Hippius Community**: [community.hippius.com](https://community.hippius.com)
- **Hippius Stats**: [hipstats.com](https://hipstats.com)
- **Hippius CLI GitHub**: [github.com/thenervelab/hippius-cli](https://github.com/thenervelab/hippius-cli)

## Security Warning

⚠️ **IMPORTANT**: Hippius uses mnemonic-based authentication with **no password recovery**. If you lose your mnemonic phrase, you permanently lose access to your account.

Always:
- Write down your mnemonic on paper and store securely
- Never share your mnemonic with anyone
- Create multiple backups in different locations
- Never commit `.env` files to version control

## Contributing

Contributions are welcome! This skill is designed to help the Hippius and Claude Code communities.

### To Contribute
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - See LICENSE file for details

## Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/hippius-claude-skill/issues)
- **Hippius Support**: [community.hippius.com](https://community.hippius.com)
- **Claude Code**: [github.com/anthropics/claude-code](https://github.com/anthropics/claude-code)

## Version

Current Version: 1.0.0

## Changelog

### 1.0.0 (2025-11-18)
- Initial release
- CLI installation automation
- IPFS upload workflow
- Storage query tools
- Comprehensive documentation
- Security best practices

---

Built with ❤️ for the Hippius and Claude Code communities
