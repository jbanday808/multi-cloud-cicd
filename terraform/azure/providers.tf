terraform {
  required_version = ">= 1.8"

  # Backend placeholder:
  # Configure remote state here when the Azure storage account, container, key,
  # and resource group names are finalized.

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  default_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
