module "minikube" {
  source = "../../modules/minikube"

  environment        = "local"
  minikube_cpu       = 2
  minikube_memory    = 4096
  kubernetes_version = "v1.30.0"
  minikube_driver    = "docker"
}
