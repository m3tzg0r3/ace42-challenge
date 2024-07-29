resource "random_password" "minio_access_key" {
  length  = 20
  special = false
}

resource "random_password" "minio_secret_key" {
  length  = 40
  special = false
}

resource "kubernetes_secret" "minio_credentials" {
  metadata {
    name      = "${var.tenant_name}-creds"
    namespace = var.namespace
  }

  data = {
    accesskey = random_password.minio_access_key.result
    secretkey = random_password.minio_secret_key.result
  }
}

resource "kubernetes_config_map" "minio_setup_script" {
  metadata {
    name      = "${var.tenant_name}-setup-script"
    namespace = var.namespace
  }

  data = {
    "setup.sh" = <<-EOT
      #!/bin/sh
      set -e

      # Install mc and curl
      apk add --no-cache wget curl

      # Download MinIO client
      wget https://dl.min.io/client/mc/release/linux-amd64/mc
      chmod +x mc
      mv mc /usr/local/bin/

      # Configure MinIO client
      mc alias set myminio ${var.minio_endpoint} $MINIO_ACCESS_KEY $MINIO_SECRET_KEY

      # Create bucket
      mc mb myminio/${var.bucket_name}

      # Download file from URL and upload to MinIO
      curl -L ${var.file_url} -o /tmp/downloaded_file
      mc cp /tmp/downloaded_file myminio/${var.bucket_name}/${var.file_name}

      # Clean up
      rm /tmp/downloaded_file
    EOT
  }
}

resource "kubernetes_job" "minio_setup" {
  metadata {
    name      = "${var.tenant_name}-setup-job"
    namespace = var.namespace
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
                name = kubernetes_secret.minio_credentials.metadata[0].name
                key  = "accesskey"
              }
            }
          }
          env {
            name = "MINIO_SECRET_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.minio_credentials.metadata[0].name
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

    backoff_limit = 4
  }

  depends_on = [
    kubernetes_secret.minio_credentials,
    kubernetes_config_map.minio_setup_script
  ]
}
