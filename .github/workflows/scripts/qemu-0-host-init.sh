#!/bin/bash

# Handle different os distro
case "$OS_DISTRO" in
  ubuntu*)
    # Install dependencies
    sudo apt-get update -y
    sudo apt-get install -y cloud-image-utils virt-manager
    ;;
  centos*)
    # TODO:
    ;;
esac
