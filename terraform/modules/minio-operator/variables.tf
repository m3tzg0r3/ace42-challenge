variable "operator_release_name" {
  description = "Release name for the MinIO Operator"
  default     = "minio-operator"
}

variable "operator_namespace" {
  description = "Namespace for the MinIO Operator"
  default     = "minio-operator"
}

variable "chart_version" {
  description = "Version of the MinIO Operator Helm chart"
  default     = "6.0.1"
}

variable "tenants_enabled" {
  description = "Enable tenants"
  type        = bool
  default     = true
}

variable "console_enabled" {
  description = "Enable console"
  type        = bool
  default     = false
}

variable "create_tenant" {
  description = "Whether to create a MinIO tenant"
  type        = bool
  default     = true
}

variable "tenant_release_name" {
  description = "Release name for the MinIO tenant"
  default     = "minio-tenant"
}

variable "tenant_namespace" {
  description = "Namespace for the MinIO tenant"
  default     = "minio-tenant"
}

variable "tenant_name" {
  description = "Name of the MinIO tenant"
  default     = "minio-tenant"
}

variable "tenant_pool_name" {
  description = "Name of the tenant pool"
  default     = "pool-0"
}

variable "tenant_servers" {
  description = "Number of MinIO servers"
  type        = number
  default     = 1
}

variable "tenant_volumes_per_server" {
  description = "Number of volumes per MinIO server"
  type        = number
  default     = 1
}

variable "tenant_volume_size" {
  description = "Size of each volume"
  default     = "100Mi"
}

variable "additional_operator_configs" {
  description = "Additional set configurations for the operator"
  type        = map(string)
  default     = {}
}

variable "additional_tenant_configs" {
  description = "Additional set configurations for the tenant"
  type        = map(string)
  default     = {}
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
