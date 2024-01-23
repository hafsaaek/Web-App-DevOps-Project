variable "client_id" {
  description = "Azure service principal client ID"
  type        = string
    }

variable "client_secret" {
  description = "Azure service principal client secret"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

# Input variables for networking module
variable "resource_group_name" {
  description = "The name of the resource group for networking"
  type        = string
  default     = "networking-resource-group"
}

variable "location" {
  description = "The Azure region for networking resources"
  type        = string
  default     = "UK South"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network (VNet)"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}