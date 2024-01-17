# variables.tf

# AKS Cluster Input Variables
variable "aks_cluster_name" {
    description = "The name of the AKS Cluster"
    type        = string
    default     = "terraform-aks-cluster"
}

variable "cluster_location" {
    description = "The Azure region where the AKS Cluster will be deployed"
    type        = string
    default     = "UK South"
}

variable "dns_prefix" {
    description = "The DNS prefix of the AKS cluster"
    type        = string
    default     = "myaks-project"
}

variable "kubernetes_version" {
    description = "The Kubernetes version the AKS cluster will use"
    type        = string
    default     = "1.26.6"
}

variable "service_principal_client_id" {
    description = "The Client ID for the service principal associated with the cluster"
    type        = string
}

variable "service_principal_secret" {
    description = "The Client Secret for the service principal associated with the cluster"
    type        = string
}

# variable "service_cidr" {
#     description = "Service  CIDR"
#     type        = string
# }

# variable "dns_service_ip" {
#     description = "DNS Service IP"
#     type        = string
# }

# Networking Module Output Variables as Input Variables
variable "resource_group_name" {
    description = "The name of the resource group"
    type        = string
    default     = "rg-devops-project"
}

variable "vnet_id" {
    description = "The ID of the already provisioned Virtual Network"
    type        = string
}

variable "control_plane_subnet_id" {
    description = "The ID of the control plane subnet"
    type        = string
}

variable "worker_node_subnet_id" {
    description = "The ID of the worker node subnet"
    type        = string
}
