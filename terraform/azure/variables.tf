variable "location" {
  description = "Azure Region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Azure Resource Group"
  type        = string
  default     = "rg-multicloud-cicd"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "multi-cloud-cicd"
}

variable "acr_name" {
  description = "Azure Container Registry"
  type        = string
  default     = "jbanday808mcicd"
}

variable "vnet_address_space" {
  description = "VNET CIDR"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Subnet CIDR"
  type        = list(string)
  default     = ["10.1.1.0/24"]
}