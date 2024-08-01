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
  minio_endpoint             = "https://minio-tenant-${var.environment}-hl.minio-tenant.svc.cluster.local:9000"
  bucket_name                = "ace42-bucket"
  file_url                   = "https://media.giphy.com/media/VdiQKDAguhDSi37gn1/giphy.gif"
  file_name                  = "ace42.gif"

}
