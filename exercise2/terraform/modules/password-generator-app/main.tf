resource "helm_release" "password-generator-app" {
  name       = var.app_name
  chart      = "../../../../exercise1/password-generator-chart"
  namespace        = var.namespace
  create_namespace = true
}

data "kubernetes_service" "load_balancer" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }

  depends_on = [ helm_release.password-generator-app ] 
}
