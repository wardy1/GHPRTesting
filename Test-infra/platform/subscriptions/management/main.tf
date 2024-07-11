module "lz_vending" {
  source  = "Azure/lz-vending/azurerm"
  version = "4.1.2" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  # Set the default location for resources
  location = var.location

  # Set the default tags for resources
  subscription_tags = var.tags

  # subscription variables
  subscription_id = var.subscription_id

  network_watcher_resource_group_enabled = false # Setting to false as LZ Module has no way currently to tag this resource group, we create the RG via the below rg creation capability where we can apply tags.

  # management group association variables
  subscription_management_group_association_enabled = false

  # resource group creation
  resource_group_creation_enabled = true
  resource_groups = {
    NetworkWatcherRG = {
      name     = "NetworkWatcherRG"
      location = var.location
      tags     = var.tags
    }
  }

  # virtual network variables
  virtual_network_enabled = true
  virtual_networks = {
    vnet-1 = {
      name                = var.vnet_name
      address_space       = var.vnet_address_spaces
      resource_group_name = var.networking_resource_group_name
      resource_group_tags = var.tags
      dns_servers         = var.vnet_dns_servers
      hub_peering_enabled = false
      /* hub_network_resource_id         = var.hub_id
      hub_peering_name_tohub          = var.hub_peering_to_name
      hub_peering_name_fromhub        = var.hub_peering_from_name */
      hub_peering_use_remote_gateways = true
      resource_group_lock_enabled     = false
    }
  }
}

## Subnets

# This Locals block maps the subnet names to the address spaces variables. It is then called in the azurerm_subnet resource block.
locals {
  subnet_names_prefixes = zipmap(var.vnet_subnet_names, var.vnet_subnet_address_spaces)
  azurerm_subnets       = [for s in azurerm_subnet.subnets : s]
  azurerm_subnets_name_id_map = {
    for index, subnet in local.azurerm_subnets :
    subnet.name => subnet.id
  }
}

# This resource block creates the subnets in the desired virtual network. It uses for_each so will loop dependent on the number of vnet_names in the list variable.
resource "azurerm_subnet" "subnets" {
  provider = azurerm.management

  for_each                                      = toset(var.vnet_subnet_names)
  address_prefixes                              = [local.subnet_names_prefixes[each.value]]
  name                                          = each.value
  resource_group_name                           = var.networking_resource_group_name
  virtual_network_name                          = var.vnet_name
  private_endpoint_network_policies             = lookup(var.subnet_private_endpoint_network_policies, each.value, "Disabled")
  private_link_service_network_policies_enabled = lookup(var.subnet_private_link_service_network_policies_enabled, each.value, false)
  service_endpoints                             = lookup(var.subnet_service_endpoints, each.value, null)

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, each.value, {})

    content {
      name = delegation.key

      service_delegation {
        name    = lookup(delegation.value, "service_name")
        actions = lookup(delegation.value, "service_actions", [])
      }
    }
  }

  depends_on = [module.lz_vending]
}
# Network Security Groups

# This resource block creates the network security groups in the desired resource group. It names the NSG based on the subnet name and replaces the subnet name prefix with nsg_.

module "nsg" {
  source  = "Azure/network-security-group/azurerm"
  version = "4.1.0"
  providers = {
    azurerm = azurerm.management
  }
  for_each            = local.nsgs
  location            = var.location
  resource_group_name = var.networking_resource_group_name
  security_group_name = each.key
  tags                = var.tags

  custom_rules     = each.value.custom_rules
  predefined_rules = []
  depends_on       = [module.lz_vending, azurerm_subnet.subnets]
}
# NSG to Subnet Association

# This locals block maps the subnet id to the NSG id. It is then called in the azurerm_subnet_network_security_group_association resource block.
locals {
  subnet_nsg_maps = zipmap(values(azurerm_subnet.subnets).*.id, values(module.nsg).*.network_security_group_id)
}

# This resource block associates the NSG to the subnet. It uses for_each based on the output of the azurerm_subnet resource block.
resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  provider                  = azurerm.management
  for_each                  = { for s in azurerm_subnet.subnets : s.name => s.id }
  subnet_id                 = each.value
  network_security_group_id = local.subnet_nsg_maps[each.value]
  depends_on                = [azurerm_subnet.subnets, module.nsg]
}


#NSG Lock
resource "azurerm_management_lock" "nsg-locks" {
  provider   = azurerm.management
  for_each   = { for n in module.nsg : n.network_security_group_name => n.network_security_group_id if var.nsg_locks_enabled }
  name       = "CanNotModify"
  scope      = each.value
  lock_level = "ReadOnly"
  notes      = "Can not modify resource or child resources"
  depends_on = [module.nsg]
}





