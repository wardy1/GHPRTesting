data "azurerm_client_config" "core" {
  provider = azurerm
}

# Obtain client configuration from the "management" provider
data "azurerm_client_config" "management" {
  provider = azurerm.management
}

# Obtain client configuration from the "connectivity" provider
data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

data "azurerm_client_config" "identity" {
  provider = azurerm.identity
}

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "6.0.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  root_parent_id   = data.azurerm_client_config.core.tenant_id
  root_id          = var.root_id
  root_name        = var.root_name
  default_location = var.default_location

  disable_base_module_tags = true
  disable_telemetry        = false

  deploy_core_landing_zones   = false // Control whether to deploy the default core landing zones // default = true
  deploy_demo_landing_zones   = false // Control whether to deploy the demo landing zones (default = false)
  deploy_corp_landing_zones   = false // Control whether or not to deploy corporate landing zones
  deploy_online_landing_zones = false // Control whether or not to deploy online landing zones
  deploy_sap_landing_zones    = false

  strict_subscription_association = false

}
