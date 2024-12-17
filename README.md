# Project "DataAnalysis" for dissertation

#### Stack: Terraform, Ansible, Docker, PostgreSQL, Bash

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
```
# execute command for initialization of terraform project and download dependencies
terraform init 
```