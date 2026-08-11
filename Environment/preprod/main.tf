# Resource Group Module
module "resource_group" {
  source = "../../modules/azurerm_resource_group"
  rgs    = var.rgs
}

# Storage Account Module
module "storage" {
  source     = "../../modules/azurerm_storage_account"
  storages   = var.storages
  depends_on = [module.resource_group]
}
