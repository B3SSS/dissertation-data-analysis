#!/bin/bash

apt install -y dirmngr ca-certificates software-properties-common apt-transport-https lsb-release curl

curl -fSsL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /usr/share/keyrings/postgresql.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/postgresql.list

apt update && apt install -y postgresql-client-15 postgresql-15
systemctl status postgresql
