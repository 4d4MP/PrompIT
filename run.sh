#!/usr/bin/env bash
set -euo pipefail

if ! command -v swift >/dev/null 2>&1; then
  echo "Error: Swift is not installed or not on PATH." >&2
  echo "Install Xcode 15+ and ensure its toolchain is available." >&2
  exit 1
fi

swift run PrompIT
