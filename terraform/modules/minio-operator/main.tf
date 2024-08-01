# locals to set helm chart values
locals {
  operator_settings = {
    "tenants.enabled"  = var.tenants_enabled
    "console.enabled"  = var.console_enabled
  }

  tenant_settings = {
    "secrets.existingSecret"            = kubernetes_secret.minio_root_config_env.metadata[0].name
    "tenant.configuration.name"         = kubernetes_secret.minio_root_config_env.metadata[0].name
    "tenant.name"                       = var.tenant_name
    "tenant.pools[0].name"              = var.tenant_pool_name
    "tenant.pools[0].servers"           = var.tenant_servers
    "tenant.pools[0].volumesPerServer"  = var.tenant_volumes_per_server
    "tenant.pools[0].size"              = var.tenant_volume_size
    "tenant.users[0].name"              = kubernetes_secret.minio_user_credentials.metadata[0].name
    "tenant.metrics.enabled"            = "true"
    "tenant.metrics.port"               = "8000"
    "tenant.metrics.protocol"           = "http"
    "tenant.prometheusOperator"         = "true"
    # "tenant.ingress.api.enabled"        = true
    "tenant.exposeServices.minio"       = "true"
  }
}

resource "kubernetes_namespace" "operator_namespace" {
  metadata {
    name = "${var.operator_namespace}"
  }
}

resource "kubernetes_namespace" "tenant_namespace" {
  metadata {
    name = "${var.tenant_namespace}"
  }
}

resource "random_password" "minio_root_access_key" {
  length  = 20
  special = false
}

resource "random_password" "minio_root_secret_key" {
  length  = 40
  special = false
}

resource "random_password" "minio_user_access_key" {
  length  = 20
  special = false
}

resource "random_password" "minio_user_secret_key" {
  length  = 40
  special = false
}

resource "kubernetes_secret" "minio_root_config_env" {
  metadata {
    name      = "${var.tenant_name}-root-config-env"
    namespace = var.tenant_namespace
  }

  data = {
    "config.env" = <<-EOT
      export MINIO_ROOT_USER=${random_password.minio_root_access_key.result}
      export MINIO_ROOT_PASSWORD=${random_password.minio_root_secret_key.result}
    EOT
  }
}

resource "kubernetes_secret" "minio_root_credentials" {
  metadata {
    name      = "${var.tenant_name}-root"
    namespace = var.tenant_namespace
  }

  data = {
    accesskey = random_password.minio_root_access_key.result
    secretkey = random_password.minio_root_secret_key.result
  }
}


resource "kubernetes_secret" "minio_user_credentials" {
  metadata {
    name      = "${var.tenant_name}-user"
    namespace = var.tenant_namespace
  }

  data = {
    CONSOLE_ACCESS_KEY = random_password.minio_user_access_key.result
    CONSOLE_SECRET_KEY = random_password.minio_user_secret_key.result
  }
}

resource "helm_release" "minio_operator" {
  name             = var.operator_release_name
  repository       = "https://operator.min.io/"
  chart            = "operator"
  namespace        = kubernetes_namespace.operator_namespace.metadata[0].name
  # create_namespace = true
  version          = var.chart_version

  wait             = true

  dynamic "set" {
    for_each = merge(local.operator_settings, var.additional_operator_configs)
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "minio_tenant" {
  name             = var.tenant_release_name
  repository       = "https://operator.min.io/"
  chart            = "tenant"
  namespace        = kubernetes_namespace.tenant_namespace.metadata[0].name
  # create_namespace = true
  version          = var.chart_version

  depends_on = [ helm_release.minio_operator ]

  wait = true

  dynamic "set" {
    for_each = merge(local.tenant_settings, var.additional_tenant_configs)
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "kubernetes_config_map" "minio_setup_script" {
  metadata {
    name      = "${var.tenant_name}-setup-script"
    namespace = var.tenant_namespace
  }

  depends_on = [ helm_release.minio_tenant ]

  data = {
    "setup.sh" = <<-EOT
      #!/bin/sh
      set -ex  # Add -x for verbose logging

      echo "Starting setup script..."

      echo "Installing mc and curl..."
      apk add --no-cache wget curl

      echo "Downloading MinIO client..."
      wget https://dl.min.io/client/mc/release/linux-amd64/mc
      chmod +x mc
      mv mc /usr/local/bin/

      echo "Configuring MinIO client..."
      # Variant using K8S Secrets
      mc alias set myminio ${var.minio_endpoint} $MINIO_ACCESS_KEY $MINIO_SECRET_KEY

      echo "Creating bucket..."
      mc mb myminio/${var.bucket_name}

      echo "Downloading and uploading file..."
      curl -L ${var.file_url} -o /tmp/downloaded_file
      mc cp /tmp/downloaded_file myminio/${var.bucket_name}/${var.file_name}

      echo "Cleaning up..."
      rm /tmp/downloaded_file

      echo "Setup complete!"
    EOT
  }
}

resource "kubernetes_job" "minio_setup" {
  metadata {
    name      = "${var.tenant_name}-setup-job"
    namespace = var.tenant_namespace
  }

  spec {
    template {
      metadata {
        name = "${var.tenant_name}-setup-pod"
      }
      spec {
        container {
          name    = "minio-setup"
          image   = "alpine:3.20.2"
          command = ["/bin/sh", "-c", "/scripts/setup.sh"]

          env {
            name = "MINIO_ACCESS_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.minio_root_credentials.metadata[0].name
                key  = "accesskey"
              }
            }
          }
          env {
            name = "MINIO_SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.minio_root_credentials.metadata[0].name
                key  = "secretkey"
              }
            }
          }

          volume_mount {
            name       = "setup-script"
            mount_path = "/scripts"
          }
        }

        volume {
          name = "setup-script"
          config_map {
            name = kubernetes_config_map.minio_setup_script.metadata[0].name
            default_mode = "0755"
          }
        }

        restart_policy = "OnFailure"
      }
    }

    backoff_limit = 10
  }

  timeouts {
    create = "2m"
    update = "2m"
  }

  depends_on = [
    helm_release.minio_tenant,
    kubernetes_secret.minio_user_credentials,
    kubernetes_config_map.minio_setup_script

  ]
}
