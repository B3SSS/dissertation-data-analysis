#!/bin/bash

wget -O /opt/node_exporter.tar.gz https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -C /opt/ -zxf /opt/node_exporter.tar.gz && mv /opt/node_exporter*/node_exporter /usr/local/bin/ && rm -rf /opt/node_exporter*

groupadd --system nodeuser
useradd -m -d /opt/node_exporter -g nodeuser -s /bin/false -c "NodeExporter" nodeuser
chown nodeuser:nodeuser /usr/local/bin/node_exporter

cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Documentation=https://prometheus.io/docs/guides/node-exporter/
Wants=network-online.target
After=network-online.target
[Service]
User=nodeuser
Group=nodeuser
Type=simple
Restart=on-failure
ExecStart=/usr/local/bin/node_exporter --web.listen-address=:9100
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now node_exporter.service
systemctl status node_exporter.service