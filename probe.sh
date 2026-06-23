#!/usr/bin/env bash
{
echo "### Illuminati build image probe — Linux"
echo "## OS"; ( . /etc/os-release; echo "$PRETTY_NAME" ); echo "arch: $(uname -m)"
echo "## Core tools"
for t in bash git curl wget tar zip unzip jq make cmake pkg-config gcc g++ clang ld openssl; do
  if command -v "$t" >/dev/null 2>&1; then printf "%-12s %s\n" "$t" "$("$t" --version 2>&1 | head -1)"; else printf "%-12s ABSENT\n" "$t"; fi
done
echo "## Languages / toolchains"
for t in node npm npx pnpm yarn corepack python3 pip3 go rustc cargo rustup dotnet java javac mvn gradle ruby php docker podman; do
  if command -v "$t" >/dev/null 2>&1; then printf "%-12s %s\n" "$t" "$("$t" --version 2>&1 | head -1)"; else printf "%-12s ABSENT\n" "$t"; fi
done
echo "## Package manager"
command -v apt-get >/dev/null 2>&1 && echo "apt-get present — 'apt-get install -y ...' works in a build step (run as root)" || echo "no apt-get"
} | tee probe.txt
exit 0
