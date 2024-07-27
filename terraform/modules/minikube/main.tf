resource "null_resource" "minikube_cluster" {
  triggers = {
    environment = var.environment
  }

  provisioner "local-exec" {
    command = "minikube start --profile=${var.environment} --driver=${var.minikube_driver} --cpus=${var.minikube_cpu} --memory=${var.minikube_memory}mb --kubernetes-version=${var.kubernetes_version}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "minikube delete --profile=${self.triggers.environment}"
  }
}

data "external" "minikube_ip" {
  program = ["sh", "-c", "echo '{\"ip\":\"'$(minikube ip --profile=${var.environment})'\"}'"]
  depends_on = [null_resource.minikube_cluster]
}
