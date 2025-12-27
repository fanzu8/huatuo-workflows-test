#!/bin/sh
set -eux

MATRIX_ARCH=$1

echo "=== Workspace ==="
pwd
ls
ls -lah /host/
ls -lah /host/_output/${MATRIX_ARCH}

echo "=== Test... ==="

# 1️⃣ Prepare
# disable es and kubelet fetching pods in huatuo-bamai.conf
sed -i -e 's/# Address.*/Address=""/g' \
/host/_output/${MATRIX_ARCH}/conf/huatuo-bamai.conf
sed -i '/KubeletClientCertPath =.*/c\\    KubeletReadOnlyPort = 0\n    KubeletAuthorizedPort = 0\n    KubeletClientCertPath = \"/etc/kubernetes/pki/apiserver-kubelet-client.crt,/etc/kubernetes/pki/apiserver-kubelet-client.key\"' \
/host/_output/${MATRIX_ARCH}/conf/huatuo-bamai.conf

# 2️⃣ Test
# just run huatuo-bamai for 60s
chmod +x /host/_output/${MATRIX_ARCH}/bin/huatuo-bamai
log_file=/tmp/huatuo-bamai.log
timeout -s SIGKILL 60s \
    /host/_output/${MATRIX_ARCH}/bin/huatuo-bamai \
    --region example \
    --config huatuo-bamai.conf \
    > $log_file 2>&1 || true
# colorize log
match_keywords="error|panic"
sed -E "s/($match_keywords)/\x1b[31m\1\x1b[0m/gI" $log_file
# check log for focus keywords
! grep -qE "$match_keywords" $log_file
