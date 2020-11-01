# about terraform configuration and Azure backup statfile.

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

# for Azure backend, you can store your statefile on Azure Cloud.

# terraform {
#   backend "azurerm" {
#     resource_group_name  = "Azure resource group name"
#     storage_account_name = "Storage Account in your resource group"
#     container_name       = "You should generate a container in your Storage Account, such as: terraform-state"
#     key                  = "Terraform Statfile Name, such as: name.terraform.tfstate"
#     access_key           = "Storage Account Access Key, you can get it from Azure portal."
#   }
# }

# for reference from other resources.

# data "terraform_remote_state" "hibro" {
#   backend = "azurerm"

#   config = {
#     storage_account_name = "same as backend azurerm block"
#     container_name       = "same as backend azurerm block"
#     key                  = "same as backend azurerm block"
#     access_key           = "same as backend azurerm block"
#   }
# }

# Just to teach you with local backend.
terraform {
  backend "local" {
    path = "statefile/hibro.terraform.tfstate"
  }
}

# for refer local statefile.

# data "terraform_remote_state" "hibro_state" {
#   backend = "local"

#   config = {
#     path = "${path.module}/statefile/hibro.terraform.tfstate"
#   }
# }
