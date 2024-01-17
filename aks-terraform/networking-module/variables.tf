variable "resource_group_name" {
    description = "The name of the resource group"
    type        = string
    default     = "rg-devops-project"
}

variable "location" {
    description = "The location of the resource group."
    type        = string
    default     = "UK South"
}

variable "vnet_address_space" {
    description = "Address space for the Virtual Network (VNet)."
    type        = list(string)
    default     = ["10.0.0.0/16"]
}