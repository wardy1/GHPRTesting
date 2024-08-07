# Configure the management resources settings.
locals {
  configure_management_resources = {
    settings = {
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                                 = var.log_retention_in_days
          enable_monitoring_for_vm                          = false
          enable_monitoring_for_vmss                        = false
          enable_solution_for_agent_health_assessment       = false
          enable_solution_for_anti_malware                  = false
          enable_solution_for_change_tracking               = false
          enable_solution_for_service_map                   = false
          enable_solution_for_sql_assessment                = false
          enable_solution_for_sql_vulnerability_assessment  = false
          enable_solution_for_sql_advanced_threat_detection = false
          enable_solution_for_updates                       = false
          enable_solution_for_vm_insights                   = false
          enable_solution_for_container_insights            = false
          enable_sentinel                                   = false
        }
      }
      security_center = {
        enabled = false
        config = {
          email_security_contact                                = var.security_alerts_email_address
          enable_defender_for_apis                              = false
          enable_defender_for_app_services                      = false
          enable_defender_for_arm                               = false
          enable_defender_for_containers                        = false
          enable_defender_for_cosmosdbs                         = false
          enable_defender_for_cspm                              = false
          enable_defender_for_dns                               = false
          enable_defender_for_key_vault                         = false
          enable_defender_for_oss_databases                     = false
          enable_defender_for_servers                           = false
          enable_defender_for_servers_vulnerability_assessments = false
          enable_defender_for_sql_servers                       = false
          enable_defender_for_sql_server_vms                    = false
          enable_defender_for_storage                           = false
        }
      }
    }

    location = var.management_resources_location
    tags     = var.management_resources_tags
    advanced = null

    location = var.management_resources_location
    tags     = var.management_resources_tags
    advanced = {
      custom_settings_by_resource_type = {
        azurerm_resource_group = {
          management = {
            name = var.management_resource_group_name
          }
        }
        azurerm_log_analytics_workspace = {
          management = {
            name = var.log_analytics_workspace_name
          }
        }
        azurerm_automation_account = {
          management = {
            name = var.automation_account_name
          }
        }
      }
    }
  }
}

