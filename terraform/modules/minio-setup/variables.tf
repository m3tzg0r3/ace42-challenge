variable "tenant_name" {
  description = "Name of the MinIO tenant"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for MinIO resources"
  type        = string
}

variable "minio_endpoint" {
  description = "MinIO endpoint URL"
  type        = string
}

variable "bucket_name" {
  description = "Name of the bucket to create in MinIO"
  type        = string
}

variable "file_url" {
  description = "URL of the file to be downloaded and uploaded to MinIO"
  type        = string
}

variable "file_name" {
  description = "Name to give the file when uploading to MinIO"
  type        = string
}
