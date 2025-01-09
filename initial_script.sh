#!/bin/bash

set -e

echo "1. Update cache and upgrade all packages"
sudo apt update && apt upgrade -y


echo "2. Install PostgreSQL 15"
sudo apt install -y dirmngr ca-certificates software-properties-common apt-transport-https lsb-release curl
curl -fSsL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /usr/share/keyrings/postgresql.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list
sudo apt update && sudo apt install -y postgresql-client-15 postgresql-15
echo "PostgreSQL 15 successfully installed"


echo "3. Install Node Exporter"
cd /opt
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
sudo tar zxf node_exporter-1.3.1.linux-amd64.tar.gz
sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin
sudo rm -rf node_exporter-*
sudo useradd -m -d /opt/node_exporter -s /bin/false -c "Node Exporter user" nodeuser
sudo chown nodeuser:nodeuser /usr/local/bin/node_exporter
cat << EOF > ~/node_exporter.service
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
sudo mv ~/node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter.service --now
echo "Node Exporter successfully installed"


echo "4. Install Postgres Exporter"
cd /opt
sudo mkdir postgres_exporter
cd /opt/postgres_exporter
sudo wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.16.0/postgres_exporter-0.16.0.linux-amd64.tar.gz
sudo tar zxf postgres_exporter-0.16.0.linux-amd64.tar.gz
sudo mv postgres_exporter-0.16.0.linux-amd64/postgres_exporter /usr/local/bin/
sudo rm -rf *
echo "DATA_SOURCE_NAME=postgresql://postgres:postgres@localhost:5432/?sslmode=disable" > ~/postgres_exporter.env
sudo mv ~/postgres_exporter.env .
cat << EOF > ~/postgres_exporter.service
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
sudo mv ~/postgres_exporter.service /etc/systemd/system/postgres_exporter.service
sudo systemctl daemon-reload
sudo systemctl enable postgres_exporter.service --now
echo "Postgres Exporter successfully installed"


echo "5. Install Prometheus"
