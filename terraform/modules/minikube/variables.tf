variable "minikube_cpu" {
  description = "Number of CPUs to allocate to Minikube"
  type        = number
  default     = 2
}

variable "minikube_memory" {
  description = "Amount of memory to allocate to Minikube (in MB)"
  type        = number
  default     = 4096
}

variable "kubernetes_version" {
  description = "Kubernetes version to use in Minikube"
  type        = string
  default     = "v1.30.0"
}

variable "minikube_driver" {
  description = "Driver to use for Minikube"
  type        = string
  default     = "docker"
}

variable "environment" {
  description = "Environment name"
  type        = string
}
