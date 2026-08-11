rgs = {
  rg1 = {
    name     = "rg-preprod-centralindia-01"
    location = "Central India"
     }
     rg2 = {
      name     = "rg-preprod-centralindia-02"
      location = "Central India"
     }
}

storages = {
  stg1 = {
    name                     = "stgpreprodcentralindia01"
    resource_group_name      = "rg-preprod-centralindia-01"
    location                 = "Central India"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    tags                     = {
      Environment = "preprod"
      ManagedBy   = "Terraform"
    }
  }
}
