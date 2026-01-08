#!/bin/bash

OS_DISTRO=${1:-ubuntu24.04}

# Install dependencies
case "$OS_DISTRO" in
  ubuntu*)
    sudo apt-get update -y
    sudo apt-get install -y cloud-image-utils virt-manager
    ;;
esac