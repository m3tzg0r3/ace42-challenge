output "minio_access_key" {
  description = "Generated MinIO access key"
  value       = random_password.minio_access_key.result
  sensitive   = true
}

output "minio_secret_key" {
  description = "Generated MinIO secret key"
  value       = random_password.minio_secret_key.result
  sensitive   = true
}
