#!/bin/sh
# Squad Architect installer
# Usage: curl -fsSL https://raw.githubusercontent.com/endorphin-ai/squad-architect/main/install.sh | bash
set -e

REPO="endorphin-ai/squad-architect"
BINARY="squad-architect"

# --- Detect platform ---
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "${OS}" in
  darwin) OS="darwin" ;;
  linux)  OS="linux" ;;
  *)
    echo "Error: unsupported OS '${OS}'. Only macOS and Linux are supported."
    exit 1
    ;;
esac

case "${ARCH}" in
  x86_64|amd64)  ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *)
    echo "Error: unsupported architecture '${ARCH}'. Only amd64 and arm64 are supported."
    exit 1
    ;;
esac

echo "Detected platform: ${OS}/${ARCH}"

# --- Fetch latest version ---
echo "Fetching latest release..."
TAG="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')"

if [ -z "${TAG}" ]; then
  echo "Error: could not determine latest release."
  exit 1
fi

VERSION="${TAG#v}"
echo "Latest version: ${TAG}"

# --- Download ---
ARCHIVE="${BINARY}_${VERSION}_${OS}_${ARCH}.tar.gz"
URL="https://github.com/${REPO}/releases/download/${TAG}/${ARCHIVE}"
CHECKSUM_URL="https://github.com/${REPO}/releases/download/${TAG}/checksums.txt"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

echo "Downloading ${ARCHIVE}..."
curl -fsSL -o "${TMPDIR}/${ARCHIVE}" "${URL}"
curl -fsSL -o "${TMPDIR}/checksums.txt" "${CHECKSUM_URL}"

# --- Verify checksum ---
echo "Verifying checksum..."
EXPECTED="$(grep "${ARCHIVE}" "${TMPDIR}/checksums.txt" | awk '{print $1}')"
if [ -z "${EXPECTED}" ]; then
  echo "Warning: checksum not found for ${ARCHIVE}, skipping verification."
else
  if command -v sha256sum >/dev/null 2>&1; then
    ACTUAL="$(sha256sum "${TMPDIR}/${ARCHIVE}" | awk '{print $1}')"
  elif command -v shasum >/dev/null 2>&1; then
    ACTUAL="$(shasum -a 256 "${TMPDIR}/${ARCHIVE}" | awk '{print $1}')"
  else
    echo "Warning: no sha256 tool found, skipping checksum verification."
    ACTUAL="${EXPECTED}"
  fi

  if [ "${ACTUAL}" != "${EXPECTED}" ]; then
    echo "Error: checksum mismatch!"
    echo "  expected: ${EXPECTED}"
    echo "  got:      ${ACTUAL}"
    exit 1
  fi
  echo "Checksum verified."
fi

# --- Extract ---
tar -xzf "${TMPDIR}/${ARCHIVE}" -C "${TMPDIR}"

# --- Install ---
INSTALL_DIR="/usr/local/bin"
if [ -w "${INSTALL_DIR}" ]; then
  mv "${TMPDIR}/${BINARY}" "${INSTALL_DIR}/${BINARY}"
else
  echo "Installing to ${INSTALL_DIR} (requires sudo)..."
  if command -v sudo >/dev/null 2>&1; then
    sudo mv "${TMPDIR}/${BINARY}" "${INSTALL_DIR}/${BINARY}"
  else
    INSTALL_DIR="${HOME}/.local/bin"
    mkdir -p "${INSTALL_DIR}"
    mv "${TMPDIR}/${BINARY}" "${INSTALL_DIR}/${BINARY}"
    echo ""
    echo "Installed to ${INSTALL_DIR}/${BINARY}"
    echo "Make sure ${INSTALL_DIR} is in your PATH:"
    echo "  export PATH=\"${INSTALL_DIR}:\${PATH}\""
  fi
fi

chmod +x "${INSTALL_DIR}/${BINARY}"

echo ""
echo "Squad Architect ${TAG} installed successfully!"
echo ""
echo "Run: ${BINARY} --help"
