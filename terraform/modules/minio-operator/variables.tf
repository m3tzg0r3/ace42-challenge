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
  default     = true
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
