#!/bin/bash

HOME_DIR=/opt/postgres_exporter

wget -O /opt/postgres_exporter.tar.gz https://github.com/prometheus-community/postgres_exporter/releases/download/v0.16.0/postgres_exporter-0.16.0.linux-amd64.tar.gz
tar -C /opt/ -zxf postgres_exporter.tar.gz && mv /opt/postgres_exporter*/postgres_exporter /usr/local/bin && rm -rf /opt/postgres_exporter*
mkdir ${HOME_DIR} && echo "DATA_SOURCE_NAME=postgresql://postgres:postgres@localhost:5432/?sslmode=disable" > ${HOME_DIR}/postgres_exporter.env
chown -R postgres:postgres ${HOME_DIR}

cat << EOF > /etc/systemd/system/postgres_exporter.service
[Unit]
Description=Prometheus exporter for PostgreSQL
Wants=network-online.target
After=network-online.target
[Service]
User=postgres
Group=postgres
WorkingDirectory=/opt/postgres_exporter
EnvironmentFile=/opt/postgres_exporter/postgres_exporter.env
ExecStart=/usr/local/bin/postgres_exporter --web.listen-address=:9109 --web.telemetry-path=/metrics
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now postgres_exporter.service