#!/bin/bash

wget -O /opt/prometheus_dir.tar.gz https://github.com/prometheus/prometheus/releases/download/v2.45.3/prometheus-2.45.3.linux-amd64.tar.gz
tar -zxf /opt/prometheus_dir.tar.gz && rm /opt/prometheus_dir.tar.gz

groupadd --system prometheus
useradd -s /sbin/nologin --system -g prometheus prometheus

mv /opt/prometheus*/prometheus /usr/local/bin && chown prometheus:prometheus /usr/local/bin/prometheus
mv /opt/prometheus*/promtool /usr/local/bin && chown prometheus:prometheus /usr/local/bin/promtool

mkdir /var/lib/prometheus && chown -R prometheus:prometheus /var/lib/prometheus
mkdir /etc/prometheus && mv /opt/prometheus*/* /etc/prometheus && chown -R prometheus:prometheus /etc/prometheus

cat << EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Background service of Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
	--config.file /etc/prometheus/prometheus.yml \
	--storage.tsdb.path /var/lib/prometheus/ \
	--web.console.templates=/etc/prometheus/consoles \
	--web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now prometheus.service