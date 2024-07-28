module "minikube" {
  source = "../../modules/minikube"

  environment        = "${var.environment}"
  minikube_cpu       = 2
  minikube_memory    = 4096
  kubernetes_version = "v1.30.0"
  minikube_driver    = "docker"
}

module "minio_operator" {
  depends_on = [module.minikube]
  source = "../../modules/minio-operator"

  operator_release_name = "minio-operator-${var.environment}"
  operator_namespace    = "minio-operator-${var.environment}}"
  chart_version         = "5.0.11"

  create_tenant         = true
  tenant_name           = "minio-tenant-${var.environment}"
  tenant_release_name   = "minio-tenant-${var.environment}"
  tenant_namespace      = "minio-tenant-${var.environment}"
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
