terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
    features {}
    client_id       = var.client_id
    client_secret   = var.client_secret
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
}


module "networking" {
    source = "./networking-module"
    resource_group_name = var.resource_group_name
    location            = var.location
    vnet_address_space  = var.vnet_address_space
    # The above are all already defined 
}


# Include AKS cluster module
module "aks_cluster" {
    source = "./aks-cluster-module"
    resource_group_name       = module.networking.resource_group_name
    vnet_id                   = module.networking.vnet_id
    control_plane_subnet_id    = module.networking.control_plane_subnet_id
    worker_node_subnet_id      = module.networking.worker_node_subnet_id
    service_principal_client_id = var.client_id
    service_principal_secret    = var.client_secret
    # Add other required variables for the AKS cluster module
    aks_cluster_name       = "terraform-aks-cluster"
    cluster_location       = "UK South"
    dns_prefix             = "myaks-project"
    kubernetes_version     = "1.26.6"
}

