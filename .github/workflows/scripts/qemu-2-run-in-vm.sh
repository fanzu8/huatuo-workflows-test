#!/usr/bin/env bash
set -euo pipefail

ARCH=${1:-amd64}
OS_DISTRO=${2:-ubuntu24.04}

echo -e "\n\n------- ARCH: $ARCH"
echo -e "------- OS_DISTRO: $OS_DISTRO"

function print_sys_info() {
    echo -e "\n\n==================== SYSTEM INFORMATION ====================\n"

    echo -e "------- OS Information:"
    uname -a
    if [ -f /etc/os-release ]; then
    echo -e "\n/etc/os-release contents:"
    cat /etc/os-release
    fi

    echo -e "\n------- PATH Environment Variable:"
    echo "$PATH" | tr ':' '\n' | awk '{printf "  %s\n", $0}'

    echo -e "\n------- CPU Information:"
    lscpu 2>/dev/null || echo "lscpu: not installed or failed"

    echo -e "\n------- Memory Information:"
    free -h

    echo -e "\n------- Network Information:"
    echo -e "\nNetwork Interfaces:"
    ip addr show 2>/dev/null || echo "ip: not installed"
    echo -e "\nRouting Table:"
    ip route show 2>/dev/null || echo "ip: not installed"

    echo -e "\n------- Disk Usage:"
    df -h

    echo -e "\n\n================== TOOLCHAIN INFORMATION ===================\n"
    echo -e "------- Go Environment:"
    if command -v go &> /dev/null; then
    go version
    echo -e "\nGo environment variables:"
    go env | grep -E "^(GO|GOROOT|GOPATH|GOVERSION)"
    else
    echo "❌ go: not installed"
    fi

    echo -e "\n------- Docker Information:"
    if command -v docker &> /dev/null; then
    docker version 2>/dev/null || true
    echo -e "\nDocker system info:"
    sudo docker info 2>/dev/null || true
    else
    echo "❌ docker: not installed"
    fi

    echo -e "\n------- k8s Information:"
    if command -v kubectl &> /dev/null; then
        kubectl get pods -A || echo "❌ kubectl: failed to get pods"
        
        echo -e "\nkubelet Information:"
        systemctl status kubelet || echo "❌ kubelet: not running"
        ps -ef |grep kubelet |grep -v grep || echo "❌ kubelet: not running"

        echo -e "\nKubelet API pods [https://127.0.0.1:10250/pods/]:"
        curl -k --cert /var/lib/kubelet/pki/kubelet-client-current.pem \
            --key /var/lib/kubelet/pki/kubelet-client-current.pem \
            --header "Content-Type: application/json" \
            'https://127.0.0.1:10250/pods/' || echo "❌ kubectl: failed to get pods"
    else
    echo "❌ kubectl: not installed"
    fi
}


print_sys_info

echo -e "\n\n======================== Test in VM ========================="
cd /mnt/host && pwd
ls -alh /mnt/host

# run integration test
./integration/integration.sh
echo -e "✅ integration test done."
