# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "f79a69b8-c7e7-413d-82c9-c7a111fc04b5"
}

provider "azurerm" {
  features {}
  alias           = "connectivity"
  subscription_id = "f79a69b8-c7e7-413d-82c9-c7a111fc04b5"
}

provider "azurerm" {
  features {}
  alias           = "identity"
  subscription_id = "f79a69b8-c7e7-413d-82c9-c7a111fc04b5"
}

provider "azurerm" {
  features {}
  alias           = "management"
  subscription_id = "f79a69b8-c7e7-413d-82c9-c7a111fc04b5"
}

terraform {
  backend "azurerm" {
    storage_account_name = "testfstateuks001"
    container_name       = "az-lz-tfstate"
    key                  = "az-lz-platform-testing.tfstate"
    use_azuread_auth     = true
  }
}
