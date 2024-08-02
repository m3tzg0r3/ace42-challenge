module "minio_operator" {
  source = "../../../modules/minio-operator"

  operator_release_name      = "minio-operator-${var.environment}"
  operator_namespace         = "minio-operator"
  chart_version              = "6.0.1"
  console_enabled            = true
  create_tenant              = true
  tenant_name                = "minio-tenant-${var.environment}"
  tenant_release_name        = "minio-tenant-${var.environment}"
  tenant_namespace           = "minio-tenant"
  tenant_servers             = 1
  tenant_volumes_per_server  = 1
  tenant_volume_size         = "10Mi"
  minio_endpoint             = "http://minio-tenant-${var.environment}-hl.minio-tenant.svc.cluster.local:9000"
  bucket_name                = "${var.environment}-bucket"
  file_url                   = "https://media.giphy.com/media/VdiQKDAguhDSi37gn1/giphy.gif"
  file_name                  = "ace42.gif"

}

module "s3www_chart" {
  source = "../../../modules/s3www-chart"

  s3www_replicas            = 1
  s3www_service_type        = "ClusterIP"
  s3www_service_port        = 80
  s3www_service_targetport  = 8080
  s3www_cpu_limit           = "100m"
  s3www_cpu_request         = "100m"
  s3www_memory_limit        = "128Mi"
  s3www_memory_request      = "128Mi"
  s3www_namespace           = module.minio_operator.tenant_namespace

  minio_bucket              = "${var.environment}-bucket"
  minio_endpoint            = module.minio_operator.minio_endpoint
  minio_access_key          = module.minio_operator.minio_root_access_key
  minio_secret_key          = module.minio_operator.minio_root_secret_key
}
