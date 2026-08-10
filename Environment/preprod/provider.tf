terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.42.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "githubtfstate1"
    container_name       = "tfstate"
    key                  = "preprod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
