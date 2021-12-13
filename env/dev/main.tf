provider "aws" {
  region  = local.aws_region
  profile = "default"
}

provider "azurerm" {
  features {}
}

locals {
  aws_region          = "us-west-2"
  azure_location      = "japaneast"
  env                 = "dev"
  resource_group_name = "rg-test-${local.env}"
}


module "aws_vpc" {
  source = "../../aws/vpc"

  vpc_name     = "aws-test-${local.env}"
  cidr_block   = "10.0.0.0/16"
  subnet_count = 1
}

module "aws_iam" {
  source = "../../aws/iam"
}

module "azure_vnet" {
  source = "../../azure/vnet"

  resource_group_name = local.resource_group_name
  location            = local.azure_location
  network_name        = "azure-test-${local.env}"
  cidr_block          = "10.1.0.0/16"
  subnet_count        = 1
}

module "azure_rg" {
  source = "../../azure/rg"

  rg_name  = local.resource_group_name
  location = local.azure_location
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-test-dev"
    storage_account_name = "tfstatetestdevkohei3110"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}