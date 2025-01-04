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
  name      = "ubuntu-flavor-11"
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
  size = "7"
  enable_online_resize = true
}

# Создание облачного сервера
resource "openstack_compute_instance_v2" "postgresql-server" {
  name              = "server"
  flavor_id         = openstack_compute_flavor_v2.flavor_1.id
  availability_zone = "ru-9a"
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



# # Описание публичного SSH ключа для ВМ 
# resource "selectel_vpc_keypair_v2" "keypair_1" {
#   name       = "keypair"
#   public_key = file("~/.ssh/id_rsa.pub")
#   user_id    = var.selectel_user_id
# }