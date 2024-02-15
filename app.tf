
resource "helm_release" "knote" {
  name             = "knote"
  repository       = "/knote"
  chart            = "knote"
  namespace        = "knote-app"
}

