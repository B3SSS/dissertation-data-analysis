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


### Import dashboards for Grafana
```yaml
node_exporter     : https://grafana.com/grafana/dashboards/1860-node-exporter-full/
postgres_exporter : https://grafana.com/grafana/dashboards/12485-postgresql-exporter/
```