#!/bin/bash
set -euo pipefail

uname --all
go version || true
docker version || true

systemctl status || true
systemctl status docker
