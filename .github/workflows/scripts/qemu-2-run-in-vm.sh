#!/bin/bash
set -Eeuo pipefail

echo "==================== SYSTEM INFO ===================="
echo "------- OS -------"
uname -a || true

if [ -f /etc/os-release ]; then
  cat /etc/os-release
fi

echo "------- PATH -------"
echo $PATH

echo "------- CPU / Memory / Network / Disk -------"
nproc || true
free -h || true
ip addr || true
ip route || true
df -h || true

echo "==================== TOOLCHAIN ======================="
go env 2>/dev/null || echo "go: not installed"
docker version 2>/dev/null || echo "docker: not installed"
