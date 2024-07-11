# This variable represents the name of the spoke subscription.
# It is of type string and has a default value of "vnet-mgmt-uksouth-01".
# The nullable attribute is set to false, meaning it cannot be left empty.
variable "subscription_name" {
  type        = string
  default     = "Management"
  description = "The name of the spoke subscription."
  nullable    = false
}

# This variable represents the ID of the spoke subscription in the Azure platform. It is a required field and cannot be left empty.
variable "subscription_id" {
  type        = string
  default     = "f79a69b8-c7e7-413d-82c9-c7a111fc04b5"
  description = "The id of the spoke subscription."
  nullable    = false
}


# This variable represents the location where the resources will be deployed.
# It is a string type with a default value of "uksouth".
# The location should not be nullable.
variable "location" {
  type        = string
  default     = "uksouth"
  description = "The default location for all resources."
  nullable    = false
}

# Define the 'tags' variable.
# This variable is used to associate tags with your resources.
# It is a map of string values, with default values provided.
variable "tags" {
  type        = map(string)
  default     = {}
  description = "The tags to associate with your resources."
  nullable    = false
}

# This variable represents the ID of the Hub Virtual Virtual Network resource.
/* variable "hub_id" {
  type    = string
  default = "/subscriptions/c20f6597-abec-4062-8957-c1be529df251/resourceGroups/rg-network-connectivity-prod-uksouth-01/providers/Microsoft.Network/virtualNetworks/vnet-connectivity-prod-uksouth-01"
}

variable "hub_peering_to_name" {
  type    = string
  default = "to-vnet-connectivity-prod-uksouth-01"
}

variable "hub_peering_from_name" {
  type    = string
  default = "to-vnet-management-prod-uksouth-01"
} */

# This variable represents the name of the networking resource group.
# It is used to specify the name of the resource group for networking resources in the "Management-Resources" environment.
variable "networking_resource_group_name" {
  type    = string
  default = "rg-network-management-prod-uksouth-01"
}

# This variable represents the name of the virtual network.
variable "vnet_name" {
  type    = string
  default = "vnet-management-prod-uksouth-01"
}
# This variable represents the custom dns servers for the virtual network.
variable "vnet_dns_servers" {
  type = list(string)
  default = [

  ]
  description = "The custom dns servers that are used by the virtual network."
}
# This variable represents the address spaces for the virtual network.
variable "vnet_address_spaces" {
  type = list(string)
  default = [
    "10.12.8.0/24"
  ]
  description = "The address spaces that are used by the virtual network."
}

# Define a variable to store a list of subnet names for the vNet.
variable "vnet_subnet_names" {
  type = list(string)
  default = [
    "snet-management-prod-uksouth-jump"
  ]
  description = "A list of subnet names for the vNet."
}

# Define the variable for vnet_subnet_address_spaces
variable "vnet_subnet_address_spaces" {
  type = list(string)
  default = [
    "10.12.8.0/28",
  ]
  description = "A address spaces for each subnet inside the vNet."
}

# This variable is used to configure the private endpoint network policies for subnets.
# It is a map that maps subnet names to a string value indicating whether the network policies are enabled or disabled for that subnet.
variable "subnet_private_endpoint_network_policies" {
  type = map(any)
  default = {
    snet-management-prod-uksouth-jump = "Enabled"
  }
  description = "A map of subnet name to enable/disable private link endpoint network policies on the subnet. Must be one of 'Enabled', 'NetworkSecurityGroupEnabled', or 'RouteTableEnabled'."
}

# This variable is used to enable or disable private link service network policies on subnets.
# It is a map that maps subnet names to boolean values, where true means network policies are enabled and false means they are disabled.
variable "subnet_private_link_service_network_policies_enabled" {
  type = map(bool)
  default = {
    snet-management-prod-uksouth-jump = true
  }
  description = "A map of subnet name to enable/disable private link service network policies on the subnet."
}

/**
 * A variable that defines the subnet delegation configuration.
 *
 * This variable is a map of subnet names to delegation blocks on the subnet.
 * Each subnet delegation block specifies the service name and service actions
 * that are allowed on the subnet.
 *
 * Example:
 * subnet_delegation = {
 *   snet-avs-prod-uksouth-anf = {
 *    "Microsoft.Netapp.volumes" = {
        service_name = "Microsoft.Netapp/volumes"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/delegations"
        ]
      }
 *   }
 * }
 */
variable "subnet_delegation" {
  type        = map(map(any))
  default     = {}
  description = "A map of subnet name to delegation block on the subnet"
}

/**
 * This variable defines a map of subnet names to service endpoints that should be added to each subnet.
 * The keys of the map represent the subnet names, and the values are lists of service endpoint names.
 * Service endpoints allow communication between subnets and specific Azure services.
 * By default, the service endpoints for each subnet are empty, but you can customize them as needed.
 */
variable "subnet_service_endpoints" {
  type = map(any)
  default = {
    snet-management-prod-uksouth-jump = []
  }
  description = "A map of subnet name to service endpoints to add to the subnet."
}

# For network security groups configuration we use a locals block instead of a variable but its used in the same way. 
# Couldnt get it to work with a variable, keep outputting empty values (could be a bug).
# We can use Variables in locals blocks though so it has its advantages. We use this so we can dynamically tell the NSG module to apply rules as ruleset will differ per NSG.
# The module hsa many predefined rules that can be used - https://registry.terraform.io/modules/Azure/network-security-group/azurerm/latest
locals {
  nsgs = {
    nsg-management-prod-uksouth-jump = {
      custom_rules     = []
      predefined_rules = []
    }
  }
}

# This variable represents whether NSG locks are enabled or not.
# If set to true, NSG locks will be enabled. If set to false, NSG locks will be disabled.
variable "nsg_locks_enabled" {
  type    = bool
  default = false
}
# Define a variable to store a list of application resource groups you wish to deploy to the subscripton.
# Add Resource groups required
# Change names to RG names in the main tf file - names neesd to be the same



