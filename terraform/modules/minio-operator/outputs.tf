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
  value       = var.create_tenant ? helm_release.minio_tenant[0].name : null
}

output "tenant_namespace" {
  description = "Namespace of the MinIO Tenant"
  value       = var.create_tenant ? helm_release.minio_tenant[0].namespace : null
}
