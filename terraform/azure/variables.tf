variable "location" {
  description = "Azure Region"
  type        = string
  default     = "East US"

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "resource_group_name" {
  description = "Azure Resource Group"
  type        = string
  default     = "rg-multicloud-cicd"

  validation {
    condition     = can(regex("^[-\\w\\._\\(\\)]+$", var.resource_group_name))
    error_message = "resource_group_name must contain only letters, numbers, underscores, hyphens, periods, or parentheses."
  }
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "multi-cloud-cicd"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,40}$", var.project_name))
    error_message = "project_name must be 3-40 characters and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, stage, prod."
  }
}

variable "acr_name" {
  description = "Azure Container Registry"
  type        = string
  default     = "jbanday808mcicd"

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{5,50}$", var.acr_name))
    error_message = "acr_name must be 5-50 alphanumeric characters."
  }
}

variable "vnet_address_space" {
  description = "VNET CIDR"
  type        = list(string)
  default     = ["10.1.0.0/16"]

  validation {
    condition     = length(var.vnet_address_space) > 0 && alltrue([for cidr in var.vnet_address_space : can(cidrhost(cidr, 0))])
    error_message = "vnet_address_space must contain at least one valid CIDR block."
  }
}

variable "subnet_address_prefix" {
  description = "Subnet CIDR"
  type        = list(string)
  default     = ["10.1.1.0/24"]

  validation {
    condition     = length(var.subnet_address_prefix) > 0 && alltrue([for cidr in var.subnet_address_prefix : can(cidrhost(cidr, 0))])
    error_message = "subnet_address_prefix must contain at least one valid CIDR block."
  }
}

variable "app_port" {
  description = "Application port allowed by the network security group."
  type        = number
  default     = 5000

  validation {
    condition     = var.app_port > 0 && var.app_port <= 65535
    error_message = "app_port must be between 1 and 65535."
  }
}

variable "app_ingress_cidrs" {
  description = "CIDR blocks allowed to reach the application."
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = length(var.app_ingress_cidrs) > 0 && alltrue([for cidr in var.app_ingress_cidrs : can(cidrhost(cidr, 0))])
    error_message = "app_ingress_cidrs must contain at least one valid CIDR block."
  }
}

variable "acr_public_network_access_enabled" {
  description = "Whether public network access is enabled for Azure Container Registry."
  type        = bool
  default     = true
}
