#!/bin/bash

CHECK=$(grep -q sse4_2 /proc/cpuinfo && echo "SSE 4.2 supported" || echo "SSE 4.2 not supported")

if [[ $CHECK == "SSE 4.2 not supported" ]]; then
    echo "SSE 4.2 not supported";
    exit 1;
fi

apt update && apt install -y apt-transport-https ca-certificates curl gnupg

curl -fsSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | sudo gpg --dearmor -o /usr/share/keyrings/clickhouse-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb stable main" | tee \
    /etc/apt/sources.list.d/clickhouse.list

apt update && apt install -y clickhouse-server clickhouse-client

systemctl enable --now clickhouse-server
systemctl status clickhouse-server