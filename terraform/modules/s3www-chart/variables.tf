variable "s3www_replicas" {
  type        = number
  description = "Number of replicas for s3www deployment"
}

variable "minio_endpoint" {
  type        = string
  description = "Endpoint URL for MinIO"
}

variable "minio_bucket" {
  type        = string
  description = "Name of the MinIO bucket"
}

variable "minio_access_key" {
  type        = string
  description = "Access key for MinIO"
}

variable "minio_secret_key" {
  type        = string
  description = "Secret key for MinIO"
}

variable "s3www_service_type" {
  type        = string
  description = "Type of Kubernetes service for s3www"
}

variable "s3www_service_port" {
  type        = number
  description = "Port for s3www service"
}

variable "s3www_service_targetport" {
  type        = number
  description = "Target port for s3www service"
}

variable "s3www_cpu_limit" {
  type        = string
  description = "CPU limit for s3www container"
}

variable "s3www_memory_limit" {
  type        = string
  description = "Memory limit for s3www container"
}

variable "s3www_cpu_request" {
  type        = string
  description = "CPU request for s3www container"
}

variable "s3www_memory_request" {
  type        = string
  description = "Memory request for s3www container"
}

variable "s3www_namespace" {
  type        = string
  description = "Namespace for the s3www deployment"
}
