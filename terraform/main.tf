terraform {
  required_providers {
    selectel  = {
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

resource "openstack_networking_network_v2" "private_network" {
  name           = "private-network"
  admin_state_up = "true"

  depends_on = [
    selectel_vpc_project_v2.project_data_analysis,
  ]
}