# Squad Architect

**by [Endorphin AI](https://endorphinai.dev/)**

Design and build multi-agent squads for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). A compiled CLI tool that orchestrates AI agent teams — from squad design through build, audit, and adjustment.

## Install

### Quick install (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/endorphin-ai/squad-architect/main/install.sh | bash
```

### Manual download

Download the binary for your platform from [GitHub Releases](https://github.com/endorphin-ai/squad-architect/releases):

| Platform | Architecture | Download |
|---|---|---|
| macOS | Apple Silicon (M1/M2/M3/M4) | `squad-architect_*_darwin_arm64.tar.gz` |
| macOS | Intel | `squad-architect_*_darwin_amd64.tar.gz` |
| Linux | x86_64 | `squad-architect_*_linux_amd64.tar.gz` |
| Linux | ARM64 | `squad-architect_*_linux_arm64.tar.gz` |

Extract and move to your PATH:

```bash
tar -xzf squad-architect_*.tar.gz
sudo mv squad-architect /usr/local/bin/
```

## Update

To update to the latest version, run the same install command again:

```bash
curl -fsSL https://raw.githubusercontent.com/endorphin-ai/squad-architect/main/install.sh | bash
```

Check your current version:

```bash
squad-architect version --code=<YOUR_CODE>
```

## Usage

All commands require an access code provided by Endorphin AI.

```bash
# Interactive squad design session
squad-architect design --code=<YOUR_CODE>

# Build squad from approved design
squad-architect build --code=<YOUR_CODE>

# Design + build in one step
squad-architect run --code=<YOUR_CODE>

# Audit an existing squad
squad-architect audit --code=<YOUR_CODE>

# Modify a squad
squad-architect adjust "your instruction" --code=<YOUR_CODE>

# Generate insight reports
squad-architect insight health --code=<YOUR_CODE>
```

## Requirements

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- macOS or Linux (amd64 or arm64)
- Access code from Endorphin AI

## Support

- Website: [endorphinai.dev](https://endorphinai.dev/)
- Issues: [GitHub Issues](https://github.com/endorphin-ai/squad-architect/issues)
