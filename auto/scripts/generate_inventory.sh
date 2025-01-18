#/bin/bash

public_ip_address=$(cd ../terraform && terraform output | grep public_ip_address | tr -d \" | cut -d " " -f 3)

cat << EOF > ../ansible/hosts.ini
[db_servers]
postgresql1 ansible_host=${public_ip_address}

[db_servers:vars]
ansible_user=ansible
ansible_ssh_private_key_file=~/.ssh/id_rsa

EOF