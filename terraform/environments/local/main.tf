module "minikube" {
  source = "../../modules/minikube"

  environment         = "${var.environment}"
  minikube_cpu        = 2
  minikube_memory     = 4096
  kubernetes_version  = "v1.30.0"
  minikube_driver     = "docker"
}

module "minio_operator" {
  depends_on = [module.minikube]
  source = "../../modules/minio-operator"

  operator_release_name      = "minio-operator-${var.environment}"
  operator_namespace         = "minio-operator"
  chart_version              = "6.0.1"
  create_tenant              = true
  tenant_name                = "minio-tenant-${var.environment}"
  tenant_release_name        = "minio-tenant-${var.environment}"
  tenant_namespace           = "minio-tenant"
  tenant_servers             = 1
  tenant_volumes_per_server  = 1
  tenant_volume_size         = "100Mi"
}
