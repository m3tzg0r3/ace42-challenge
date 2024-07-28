module "minikube" {
  source = "../../modules/minikube"

  environment        = "local"
  minikube_cpu       = 2
  minikube_memory    = 4096
  kubernetes_version = "v1.30.0"
  minikube_driver    = "docker"
}

module "minio_operator" {
  source = "../../modules/minio-operator"

  operator_release_name = "minio-operator-local"
  operator_namespace    = "minio-operator-local"
  chart_version         = "5.0.11"

  create_tenant         = true
  tenant_name           = "minio-tenant-local"
  tenant_release_name   = "minio-tenant-local"
  tenant_namespace      = "minio-tenant-local"
  tenant_servers        = 1
  tenant_volumes_per_server = 1
  tenant_volume_size    = "100Mi"

  additional_set_configs = [
    {
      name  = "resources.requests.memory"
      value = "256Mi"
    }
  ]
}
