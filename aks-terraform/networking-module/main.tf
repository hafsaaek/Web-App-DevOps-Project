#  Within the networking module's main.tf configuration file, define the essential networking resources for an AKS cluster. This includes creating an Azure Resource Group, a VNet, two subnets (for the control plane and worker nodes) and a Network Security Group (NSG). Please name these resources as follows:
    # Azure Resource Group: Name this resource by referencing the resource_group_name variable created earlier
    # Virtual Network (VNet): aks-vnet
    # Control Plane Subnet: control-plane-subnet
    # Worker Node Subnet: worker-node-subnet
    # Network Security Group (NSG): aks-nsg
# Within the NSG, define two inbound rules: one to allow traffic to the kube-apiserver (named kube-apiserver-rule) and one to allow inbound SSH traffic (named ssh-rule). Both rules should only allow inbound traffic from your public IP address.

resource "azurerm_resource_group" "networking" {
    name        = var.resource_group_name
    location    = var.location
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks_vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
}

resource "azurerm_subnet" "control_plane_subnet" {
  name                 = "control_plane_subnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "worker_node_subnet" {
  name                 = "worker_node_subnet"
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Within the NSG, define two inbound rules: one to allow traffic to the kube-apiserver (named kube-apiserver-rule) and one to allow inbound SSH traffic (named ssh-rule). Both rules should only allow inbound traffic from your public IP address.
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "aks-nsg"
  location            = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
}

#  Allow inbound traffic to kube-apiserver (TCP/443) from your public IP address
resource "azurerm_network_security_rule" "kube_apiserver_rule" {
  name                        = "kube_apiserver_rule"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6443"
  source_address_prefix       = "172.20.10.4"  # Replace with your public IP or IP range
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.networking.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
}

resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "ssh-rule"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "172.20.10.4"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.networking.name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
}