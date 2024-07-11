terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.74.0"
    }
    azapi = {
      source = "azure/azapi"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "f79a69b8-c7e7-413d-82c9-c7a111fc04b5"
}

provider "azurerm" {
  features {}
  alias           = "management"
  subscription_id = "f79a69b8-c7e7-413d-82c9-c7a111fc04b5"
}

provider "azapi" {
  subscription_id = "f79a69b8-c7e7-413d-82c9-c7a111fc04b5"
  use_msi         = false
}

terraform {
  backend "azurerm" {
    storage_account_name = "testfstateuks001"
    container_name       = "az-lz-tfstate"
    key                  = "az-lz-management-testing.tfstate"
    use_azuread_auth     = true
  }
}

