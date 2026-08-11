# ☁️ Azure Infrastructure Management with Terraform 🚀

Welcome to the **Git-hub-practice** repository! 🌟  
This repository provides a **modular**, **scalable**, and **multi-environment** Infrastructure as Code (IaC) framework built using **Terraform** to seamlessly provision and manage Microsoft Azure resources.

---

## 📌 Key Features

- 🏗️ **Modular Architecture**: Clean separation between reusable infrastructure modules (`modules/`) and environment configurations (`Environment/`).
- ⚡ **Dynamic Resource Provisioning**: Leverages Terraform `for_each` loops to dynamically instantiate multiple Azure resources from map definitions.
- 🌐 **Multi-Environment Support**: Isolated configurations for pre-production (`preprod`) and production (`production`) environments.
- 🤖 **Automated CI/CD Pipeline**: GitHub Actions workflows for automated format checking, plan previews on PRs, and automatic deployments on push.
- 🔐 **Remote State Management**: Pre-configured Azure Blob Storage backend with state locking for team collaboration and data safety.
- 📝 **Declarative Configuration**: Simplified variable management using environment-specific `.tfvars` files.

---

## 📁 Project Directory Structure

```text
.
├── 🤖 .github/
│   └── ⚙️ workflows/
│       └── 📜 terraform.yml               # GitHub Actions CI/CD Pipeline
├── 🌍 Environment/
│   ├── 🧪 preprod/
│   │   ├── 📜 main.tf                    # Environment module calls
│   │   ├── 🔑 provider.tf                # AzureRM provider & remote backend config
│   │   ├── 📋 variables.tf               # Environment variable declarations
│   │   ├── ⚙️ terraform.tfvars           # Pre-production input variable values
│   │   └── 📄 terraform.tfvars.example   # Template variable values file
│   └── 🏭 production/                    # Production environment folder
└── 🧩 modules/
    ├── 📦 azurerm_resource_group/        # Resource Group module
    │   ├── 📜 main.tf                    # azurerm_resource_group resource definition
    │   └── 📋 variables.tf               # Module input variables
    └── 💾 azurerm_storage_account/       # Storage Account module
        ├── 📜 main.tf                    # azurerm_storage_account resource definition
        └── 📋 variables.tf               # Module input variables
```

---

## 🛠️ Modules Overview

### 📦 1. `azurerm_resource_group`
Provisions Azure Resource Groups dynamically based on a map of resource group definitions.

- 📍 **Source Location**: `modules/azurerm_resource_group`
- 📥 **Inputs**:
  - `rgs` *(map)*: Map of resource group objects containing `name` and `location`.

### 💾 2. `azurerm_storage_account`
Provisions Azure Storage Accounts dynamically linked to designated resource groups.

- 📍 **Source Location**: `modules/azurerm_storage_account`
- 📥 **Inputs**:
  - `storages` *(map)*: Map of storage account objects containing `name`, `resource_group_name`, `location`, `account_tier`, and `account_replication_type`.
- 🔗 **Dependencies**: Explicitly depends on `module.resource_group` (`depends_on`).

---

## 🤖 GitHub Actions CI/CD Pipeline

The repository includes a fully automated GitHub Actions workflow located at [.github/workflows/terraform.yml](file:///e:/DevOps/GITHUB%20Practice/.github/workflows/terraform.yml).

### ⚙️ Pipeline Triggers & Jobs

1. 🖌️ **Terraform Format & Lint** (`lint`): Runs `terraform fmt -check -recursive` on every PR or push.
2. 📖 **Terraform Plan & PR Comment** (`plan`): Runs `terraform init`, `terraform validate`, and `terraform plan`, automatically adding a comment with the execution plan on open Pull Requests.
3. 🚀 **Terraform Apply** (`apply`): Triggers automatically when code is merged into `main`, or via manual workflow dispatch.
4. 🧹 **Terraform Destroy** (`destroy`): Can be executed manually via `workflow_dispatch` for environment teardown.

### 🔑 Required GitHub Repository Secrets

Configure the following secrets in **GitHub Repository Settings ➔ Secrets and variables ➔ Actions**:

| Secret Name | Description |
| :--- | :--- |
| `AZURE_CLIENT_ID` | Application (Client) ID of the Azure App Registration / Service Principal |
| `AZURE_TENANT_ID` | Azure Active Directory / Entra ID Tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Target Azure Subscription ID |

---

## ⚙️ Prerequisites

Before deploying infrastructure locally or via GitHub Actions, verify you have:

- 🛠️ **Terraform CLI** (v1.5.0+): [Download Terraform](https://developer.hashicorp.com/terraform/downloads)
- 💻 **Azure CLI**: [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- 🔑 **Azure Subscription**: Active subscription with Owner/Contributor access.
- 🗄️ **Remote State Backend**: Azure Storage Account pre-configured for `.tfstate` storage:
  - 📂 **Resource Group**: `rg-terraform-state`
  - 🗃️ **Storage Account**: `githubtfstate1`
  - 📦 **Container**: `tfstate`

---

## 🚀 Step-by-Step Local Deployment Guide

### 🔑 Step 1: Authenticate with Azure
Log in to your Azure account via Azure CLI:
```bash
az login
```
Set your active subscription (if you have multiple subscriptions):
```bash
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

---

### 📂 Step 2: Navigate to Target Environment
Select the environment you wish to deploy (e.g., `preprod`):
```bash
cd Environment/preprod
```

---

### ⚙️ Step 3: Initialize Terraform
Initialize the working directory, download the AzureRM provider plugin (`v5.42.0`), and configure the remote backend:
```bash
terraform init
```

---

### 🔍 Step 4: Preview Execution Plan
Generate and inspect an execution plan to verify resources to be created:
```bash
terraform plan -var-file="terraform.tfvars"
```

---

### 🎯 Step 5: Apply & Provision Infrastructure
Deploy the resources to your Azure subscription:
```bash
terraform apply -var-file="terraform.tfvars" -auto-approve
```

---

### 🧹 Step 6: Destroy / Teardown Infrastructure
To clean up and remove all provisioned resources when no longer needed:
```bash
terraform destroy -var-file="terraform.tfvars"
```

---

## 📝 Configuration Example (`terraform.tfvars`)

```hcl
# 📦 Resource Group Configuration
rgs = {
  rg1 = {
    name     = "rg-preprod-centralindia-01"
    location = "Central India"
    tags     = {
      Environment = "preprod"
      ManagedBy   = "Terraform"
    }
  }
}

# 💾 Storage Account Configuration
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
```

---

## 🔒 DevOps & IaC Best Practices

- 🛡️ **Centralized State Locking**: Prevents concurrent execution conflicts using Azure Blob Storage leases.
- 🧩 **DRY (Don't Repeat Yourself)**: Infrastructure code is modularized for maximum reusability across teams and environments.
- 🏷️ **Resource Tagging**: Consistent tag enforcement (`Environment`, `ManagedBy`) across all resources for cost management and auditing.
- 🔒 **Environment Isolation**: Prevents accidental changes to production by maintaining distinct state files per environment (`preprod.terraform.tfstate`).

---

## 📄 License & Maintainer
This repository is maintained for **Azure DevOps & Infrastructure as Code Practice**. 🚀
