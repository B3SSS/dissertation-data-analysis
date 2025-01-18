# Project "DataAnalysis" for dissertation

#### Stack: Terraform, Ansible, Docker, PostgreSQL, Python, Bash

### Add .terraformrc in user home directory
```
provider_installation {
  network_mirror {
    url = "https://mirror.selectel.ru/3rd-party/terraform-registry/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

### Plan 
#### 1. Auto
```bash
# Execute command for initialization and installation of Terraform project and download dependencies
cd terraform/
terraform init
terraform apply

# Generate hosts.ini file for Ansible
cd ansible/
python3 -m venv .venv
source .venv/bin/activate
pip3 install -r requirements.txt
python3 gen_inventory.py

# Start Ansible playbook
ansible-playbook -i hosts.ini main_playbook.yaml
```

#### 2. Manual
```bash
# Connect to server
  # Copy private key to server
ssh-copy-id -i /path/to/private/key root@ip.ip.ip.ip
  # Copy scripts to server
scp -i /path/to/private/key ./manual/* root@ip.ip.ip.ip:~/
  # Login
ssh -i /path/to/private/key root@ip.ip.ip.ip
  # Run scripts from root directory
bash ./postgres15.sh
bash ./node_exporter.sh
bash ./postgres_exporter.sh
bash ./prometheus.sh
bash ./grafana.sh

  # Create tables (DDL)
sudo su - postgres
psql -U postgres -d postgres

\i ddl.sql
```


### Import dashboards for Grafana
```yaml
node_exporter     : https://grafana.com/grafana/dashboards/1860-node-exporter-full/
postgres_exporter : https://grafana.com/grafana/dashboards/12485-postgresql-exporter/
```


