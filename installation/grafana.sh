#!/bin/bash

wget https://mirrors.cloud.tencent.com/grafana/apt/pool/main/g/grafana-enterprise/grafana-enterprise_10.2.3_amd64.deb
apt install adduser libfontconfig1 musl -y && apt --fix-broken install
dpkg -i grafana-enterprise_*_amd64.deb

systemctl enable --now grafana-server
systemctl status grafana-server