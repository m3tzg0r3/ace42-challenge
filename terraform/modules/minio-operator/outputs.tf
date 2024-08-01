output "operator_release_name" {
  description = "Release name of the MinIO Operator"
  value       = helm_release.minio_operator.name
}

output "operator_namespace" {
  description = "Namespace of the MinIO Operator"
  value       = helm_release.minio_operator.namespace
}

output "tenant_release_name" {
  description = "Release name of the MinIO Tenant"
  value       = var.create_tenant ? helm_release.minio_tenant.name : null
}

output "tenant_namespace" {
  description = "Namespace of the MinIO Tenant"
  value       = var.create_tenant ? helm_release.minio_tenant.namespace : null
}

output "minio_endpoint" {
  description = "S3 service endpoint of the MinIO Tenant"
  value       = var.minio_endpoint
}

output "minio_user_access_key" {
  description = "Generated MinIO access key"
  value       = random_password.minio_user_access_key.result
  sensitive   = true
}

output "minio_user_secret_key" {
  description = "Generated MinIO secret key"
  value       = random_password.minio_user_secret_key.result
  sensitive   = true
}

output "minio_root_access_key" {
  description = "Generated MinIO access key"
  value       = random_password.minio_root_access_key.result
  sensitive   = true
}

output "minio_root_secret_key" {
  description = "Generated MinIO secret key"
  value       = random_password.minio_root_secret_key.result
  sensitive   = true
}
