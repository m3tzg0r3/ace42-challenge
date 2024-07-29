output "minikube_ip" {
  value = module.minikube.minikube_ip
}

output "kubectl_context" {
  value = module.minikube.kubectl_context
}
