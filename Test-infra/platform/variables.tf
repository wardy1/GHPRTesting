# Use variables to customise the deployment

variable "root_id" {
  type    = string
  default = "jw"
}

variable "root_name" {
  type    = string
  default = "jwtest"
}

variable "default_location" {
  type    = string
  default = "uksouth"
}

variable "policy_effect_audit" {
  type    = string
  default = "Audit"
}

variable "policy_effect_deny" {
  type    = string
  default = "Deny"
}

