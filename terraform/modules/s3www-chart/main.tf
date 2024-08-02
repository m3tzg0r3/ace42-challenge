locals {
  s3www_settings = {
    "replicaCount"              = var.s3www_replicas
    "s3.endpoint"               = var.minio_endpoint
    "s3.bucket"                 = var.minio_bucket
    "s3.accessKey"              = var.minio_access_key
    "s3.secretKey"              = var.minio_secret_key
    "service.type"              = var.s3www_service_type
    "service.port"              = var.s3www_service_port
    "service.targetPort"        = var.s3www_service_targetport
    "resources.limits.cpu"      = var.s3www_cpu_limit
    "resources.limits.memory"   = var.s3www_memory_limit
    "resources.requests.cpu"    = var.s3www_cpu_request
    "resources.requests.memory" = var.s3www_memory_request
  }
}

# resource "kubernetes_namespace" "s3www_namespace" {
#   metadata {
#     name = var.s3www_namespace
#   }
# }

resource "kubernetes_secret" "s3www" {
  metadata {
    name      = "s3www"
    namespace = var.s3www_namespace
  }
  data = {
    access-key = var.minio_access_key
    secret-key = var.minio_secret_key
  }
}

resource "helm_release" "s3www" {
  name       = "s3www"
  chart      = "${path.module}/../../../helm/s3www-chart/"
  namespace  = var.s3www_namespace

  dynamic "set" {
    for_each = merge(local.s3www_settings)
    content {
      name  = set.key
      value = set.value
    }
  }
}
