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

resource "null_resource" "switch_minikube_profile" {
  depends_on = [null_resource.minikube_cluster]
  provisioner "local-exec" {
    command = "minikube profile ${var.environment}"
  }
}

data "external" "minikube_ip" {
  depends_on = [null_resource.minikube_cluster]
  program = ["sh", "-c", "echo '{\"ip\":\"'$(minikube ip --profile=${var.environment})'\"}'"]
}
