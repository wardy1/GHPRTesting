variable "deploy_management_resources" {
  type    = bool
  default = true
}
variable "log_retention_in_days" {
  type    = number
  default = 30
}

variable "security_alerts_email_address" {
  type    = string
  default = ""
}

variable "management_resources_location" {
  type    = string
  default = "uksouth"
}

variable "management_resources_tags" {
  type = map(string)
  default = {
    "ApplicationName" = "Azure landing Zone - Management"
    "Approver"        = "TBC"
    "BusinessUnit"    = "TBC"
    "Environment"     = "Platform - Management"
    "Owner"           = "TBC"
    "StartDate"       = "05 July 2024"
  }
}

variable "management_resource_group_name" {
  type    = string
  default = "rg-logs-management-uksouth-001"
}

variable "log_analytics_workspace_name" {
  type    = string
  default = "ala-management-uksouth-001"
}

variable "automation_account_name" {
  type    = string
  default = "aa-management-uksouth-001"
}
