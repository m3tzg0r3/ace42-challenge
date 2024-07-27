output "minikube_ip" {
  value       = null_resource.minikube_cluster.id != "" ? trimspace(data.external.minikube_ip.result["ip"]) : ""
  description = "The IP address of the Minikube cluster"
}

output "kubectl_context" {
  value       = var.environment
  description = "The kubectl context for the Minikube cluster"
}
