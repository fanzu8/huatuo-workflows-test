#!/usr/bin/env bash
set -euo pipefail

ARCH=${1:-amd64}
OS_DISTRO=${2:-ubuntu24.04}

# Handle different os distro
case "$OS_DISTRO" in
  ubuntu*)
    # Install dependencies
    sudo apt-get update -y
    sudo apt-get install -y cloud-image-utils virt-manager qemu-utils qemu-system-arm
    ;;
#   centos*)
#     # TODO:
  *)
    echo -e "❌ Unsupported OS distro: '$OS_DISTRO'" >&2
    echo -e " Supported distros: ubuntu*" >&2
    exit 1
    ;;
esac
