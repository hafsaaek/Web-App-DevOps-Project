
output "aks_cluster_name" {
  description = "The name of the provisioned AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_id" {
  description = "The ID of the provisioned AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_kubeconfig" {
  description = "The Kubernetes configuration file for the provisioned AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config[0]["content"]
}