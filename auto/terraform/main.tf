terraform {
  required_providers {
    selectel = {
      source  = "selectel/selectel"
      version = "5.3.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "2.0.0"
    }
  }
}

provider "selectel" {
  domain_name = var.selectel_domain_name
  username    = var.selectel_service_user_name
  password    = var.selectel_service_user_password
}

resource "selectel_vpc_project_v2" "project_data_analysis" {
  name = var.selectel_project_name
}

provider "openstack" {
  auth_url    = "https://cloud.api.selcloud.ru/identity/v3"
  domain_name = var.selectel_domain_name
  tenant_id   = selectel_vpc_project_v2.project_data_analysis.id
  user_name   = var.selectel_service_user_name
  password    = var.selectel_service_user_password
  region      = var.selectel_region
}

# Слепок конфигурации необходимой ВМ
resource "openstack_compute_flavor_v2" "flavor_1" {
  name      = "my-ubuntu-flavor"
  vcpus     = 2
  ram       = 2048
  disk      = 0
  is_public = false

  lifecycle {
    create_before_destroy = true
  }
}

# Создание приватной сети и подсети
resource "openstack_networking_network_v2" "network_1" {
  name           = "private-network"
  admin_state_up = "true"
}
resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "private-subnet"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.199.0/24"
}

# Создание облачного роутера, подключенного к внешней сети
data "openstack_networking_network_v2" "external_network_1" {
  external = true
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "router"
  external_network_id = data.openstack_networking_network_v2.external_network_1.id
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}

# Создание порта для облачного сервера
resource "openstack_networking_port_v2" "port" {
  name       = "port"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

# Получение образа для ВМ
data "openstack_images_image_v2" "image_1" {
  name        = "Ubuntu 20.04 LTS 64-bit"
  most_recent = true
  visibility  = "public"
}

# Создание загрузочного сетевого диска
resource "openstack_blockstorage_volume_v3" "volume_1" {
  name     = "boot-volume-for-server"
  size     = "5"
  image_id = data.openstack_images_image_v2.image_1.id
  enable_online_resize = true

  lifecycle {
    ignore_changes = [image_id]
  }

}

# Создание дополнительного сетевого диска
resource "openstack_blockstorage_volume_v3" "volume_2" {
  name = "additional-volume-for-server"
  size = "20"
  enable_online_resize = true
}

# Создание облачного сервера
resource "openstack_compute_instance_v2" "postgresql-server" {
  name              = "postgresql1"
  flavor_id         = openstack_compute_flavor_v2.flavor_1.id
  availability_zone = "ru-9a"
  user_data = <<-EOF
    #!/bin/bash
    LOG="/opt/terratest.log"
    apt update && apt upgrade -y >> $LOG
    useradd -m -d /home/ansible -p $(perl -e 'print crypt($ARGV[0], "password")' 'ansible') -s /bin/bash ansible
    mkdir /home/ansible/.ssh
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDgTYJRC+99GosRbYE1xakrr7VhBh1xzSnIKocmGYfd6JyOqSV9YmWtNOkRBXkAwfDZhBAEVGjJsDbwIHiYsxfjJ53R7VqC4o0zjc9okBMmpX34n2LOxrZ+7KDokriokgtwG0qTiN/uiD+8O09FF2RRSM0KuOYkANKdLQVl8RLHj6d0G4Elq3hQDxV8sR5SNFuUP+npsSkHx0HCPtEh14/zaYvgSPSwXL1TOI3yN7qZOJGOBK0Bvqwrwbkbn3ziRqwOef4uevY7we6hFMt1Q9rlB0dcKOdZ/gg1uSVYVQh8bd5QiC6inA2pEj3IEZKaB0oAkbCdNBv49LPvL85b8qA1xLNLDoOVwdsojQN1bCexPyJ4iqPqUhbGSkqmt/fGzA8YcLRb4vduf0H2d3i3KSdxI1BDDW5sRaWbChg20fBgb47DknlEBKtrzOGnwMuo7TDy2d/dSqyg/V1C8v4GMBtZ0qD8RSRj8cwpNd/6SxQVDsKiud0YI8ksqTxTdspgrCE= duvar@DESKTOP-QGLQVE0" >> /home/ansible/.ssh/authorized_keys
    chown -R ansible:ansible /home/ansible
    echo "ansible  ALL=(ALL:ALL)  NOPASSWD: ALL" > /etc/sudoers.d/ansible
    reboot
  EOF
  network {
    port = openstack_networking_port_v2.port.id
  }
  lifecycle {
    ignore_changes = [image_id]
  }
  block_device {
    uuid             = openstack_blockstorage_volume_v3.volume_1.id
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = 0
  }
  block_device {
    uuid             = openstack_blockstorage_volume_v3.volume_2.id
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = -1
  }
  vendor_options {
    ignore_resize_confirmation = true
  }
}

# Создание публичного адреса
resource "openstack_networking_floatingip_v2" "floatingip_1" {
  pool = "external-network"
}

# Назначить ассоциацию публичного и приватного IP-адреса облачного сервера
resource "openstack_networking_floatingip_associate_v2" "association_1" {
  port_id     = openstack_networking_port_v2.port.id
  floating_ip = openstack_networking_floatingip_v2.floatingip_1.address
}

output "public_ip_address" {
  value = openstack_networking_floatingip_v2.floatingip_1.address
}