resource "helm_release" "example" {
  name       = "my-password-generator-app"
  chart      = "../../../../exercise1/password-generator-chart"
  namespace        = "password-generator-app"
  create_namespace = true
}