resource "helm_release" "minio_operator" {
  name             = var.operator_release_name
  repository       = "https://operator.min.io/"
  chart            = "operator"
  namespace        = var.operator_namespace
  create_namespace = true
  version          = var.chart_version

  wait             = true
  wait_for_jobs    = true

  set {
    name  = "tenants.enabled"
    value = tostring(var.tenants_enabled)
  }

  set {
    name  = "console.enabled"
    value = tostring(var.console_enabled)
  }

  dynamic "set" {
    for_each = var.additional_set_configs
    content {
      name  = set.value.name
      value = set.value.value
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

  set {
    name  = "tenant.name"
    value = var.tenant_name
  }

  set {
    name  = "tenant.pools[0].servers"
    value = tostring(var.tenant_servers)
  }

  set {
    name  = "tenant.pools[0].volumesPerServer"
    value = tostring(var.tenant_volumes_per_server)
  }

  set {
    name  = "tenant.pools[0].size"
    value = var.tenant_volume_size
  }

  dynamic "set" {
    for_each = var.additional_tenant_configs
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}
