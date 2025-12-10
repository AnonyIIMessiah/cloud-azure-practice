
terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~>3.0" }
    random  = { source = "hashicorp/random",  version = "~>3.0" }
  }

  
  backend "azurerm" {
    resource_group_name  = "yc-basics-rg-12345"        
    storage_account_name = "ycbasicstfstate"        
    container_name       = "tfstate"
    key                  = "3tier-capstone.tfstate"
  }
}



provider "azurerm" {
  # Configuration options
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false   # ← THIS LINE UNLOCKS DELETION
    }
    }
  subscription_id = var.subscription_id
}


data "azurerm_client_config" "current" {}

locals {
  prefix = "yc3tier"
  tags = {
    Environment = "Capstone"
    Project     = "AzureMastery2025"
    Owner       = "you"
  }
}

# ==================== 1. RESOURCE GROUP ====================
resource "azurerm_resource_group" "rg" {
  name     = "yc-3tier-rg"
  location = "centralindia"  # Your region from error
  tags     = local.tags
}

# ==================== SQL SERVER + DATABASE ====================
# resource "azurerm_mssql_server" "sql" {
#   name                         = "${local.prefix}-sql"
#   resource_group_name          = azurerm_resource_group.rg.name
#   location                     = azurerm_resource_group.rg.location
#   version                      = "12.0"
#   administrator_login          = "sqladmin"
#   administrator_login_password = "P@ssw0rd1234!"
#   minimum_tls_version          = "1.2"
#   public_network_access_enabled = true
#   tags                         = local.tags
# }

# resource "azurerm_mssql_database" "db" {
#   name                        = "leaderboard-db"
#   server_id                   = azurerm_mssql_server.sql.id
#   sku_name                    = "Basic"  # DTU Basic – 0 vCores, avoids quota
#   max_size_gb                 = 2
#   depends_on                  = [azurerm_mssql_server.sql]
#   tags                        = local.tags
# }

# # Firewall – allow Azure services
# resource "azurerm_mssql_firewall_rule" "azure" {
#   name             = "AllowAzureServices"
#   server_id        = azurerm_mssql_server.sql.id
#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "0.0.0.0"
# }

# # ==================== KEY VAULT ====================
# resource "azurerm_key_vault" "kv" {
#   name                        = "${local.prefix}kv2025"
#   location                    = azurerm_resource_group.rg.location
#   resource_group_name         = azurerm_resource_group.rg.name
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   sku_name                    = "standard"
#   purge_protection_enabled    = false
#   enabled_for_deployment      = true

#   # FIXED: Disable RBAC, use Access Policies
#   enable_rbac_authorization   = false

#   network_acls {
#     default_action = "Allow"
#     bypass         = "AzureServices"
#   }
#   tags = local.tags
# }

#  
# resource "azurerm_key_vault_access_policy" "terraform_user" {
#   key_vault_id = azurerm_key_vault.kv.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azurerm_client_config.current.object_id  # Your user ID

#   secret_permissions = [
#     "Get", "List", "Set", "Delete", "Backup", "Restore", "Recover"
#   ]
#   depends_on = [azurerm_key_vault.kv]
# }

# ==================== BACKEND APP SERVICE (API) ====================
resource "azurerm_service_plan" "plan" {
  name                = "${local.prefix}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"  
  tags                = local.tags
}

resource "azurerm_linux_web_app" "api" {
  name                = "${local.prefix}-api"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  site_config {
    application_stack {
      node_version = "20-lts"
    }
  }

  identity { type = "SystemAssigned" }

  app_settings = {
    KEY_VAULT_NAME = azurerm_key_vault.kv.name
  }

  tags = local.tags
}

# FIXED: Access Policy for Backend MI – after app creation
resource "azurerm_key_vault_access_policy" "api_mi" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.api.identity[0].principal_id

  secret_permissions = ["Get"]
  depends_on         = [azurerm_linux_web_app.api]  # FIXED: Ensure app exists first
}

# ==================== FRONTEND APP SERVICE ====================
resource "azurerm_linux_web_app" "frontend" {
  name                = "${local.prefix}-frontend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id  # Shared plan
  https_only          = true

  site_config {
    application_stack {
      node_version = "20-lts"
    }
  }

  app_settings = {
    REACT_APP_API_URL = "https://${azurerm_linux_web_app.api.default_hostname}"
  }

  tags = local.tags
}

# ==================== OUTPUTS ====================
output "frontend_url" { value = "https://${azurerm_linux_web_app.frontend.default_hostname}" }
output "api_url"       { value = "https://${azurerm_linux_web_app.api.default_hostname}" }
# output "sql_server"    { value = azurerm_mssql_server.sql.fully_qualified_domain_name }
# output "kv_name"       { value = azurerm_key_vault.kv.name }