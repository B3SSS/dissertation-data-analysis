variable "selectel_project_name" {
  description = "Project Name"
  type = string
  nullable = false
}

variable "selectel_domain_name" {
  description = "Selectel account number"
  type = string
  nullable = false
}

variable "selectel_service_user_name" {
  description = "Name of service user"
  type = string
  nullable = false
}

variable "selectel_service_user_password" {
  description = "Password of service user"
  type = string
  nullable = false
}

variable "selectel_region" {
  description = "Region for infrastructure creation"
  type = string
  nullable = false
}