locals {
  operator_settings = {
    "tenants.enabled"  = var.tenants_enabled
    "console.enabled"  = var.console_enabled
  }

  tenant_settings = var.create_tenant ? {
    "tenant.name"                       = var.tenant_name
    "tenant.pools[0].name"              = var.tenant_pool_name
    "tenant.pools[0].servers"           = var.tenant_servers
    "tenant.pools[0].volumesPerServer"  = var.tenant_volumes_per_server
    "tenant.pools[0].size"              = var.tenant_volume_size
  } : {}
}

resource "helm_release" "minio_operator" {
  name             = var.operator_release_name
  repository       = "https://operator.min.io/"
  chart            = "operator"
  namespace        = var.operator_namespace
  create_namespace = true
  version          = var.chart_version

  wait             = true
  wait_for_jobs    = true

  dynamic "set" {
    for_each = merge(local.operator_settings, var.additional_operator_configs)
    content {
      name  = set.key
      value = tostring(set.value)
    }
  }
}

resource "helm_release" "minio_tenant" {
  count            = var.create_tenant ? 1 : 0
  name             = var.tenant_release_name
  repository       = "https://operator.min.io/"
  chart            = "tenant"
  namespace        = var.tenant_namespace
  create_namespace = true
  version          = var.chart_version

  depends_on = [helm_release.minio_operator]

  dynamic "set" {
    for_each = merge(local.tenant_settings, var.additional_tenant_configs)
    content {
      name  = set.key
      value = tostring(set.value)
    }
  }
}
