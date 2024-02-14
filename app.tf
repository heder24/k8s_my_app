resource "kubernetes_namespace" "knote_app" {
  metadata {
    name = "knote-app"
  }
}

resource "helm_release" "knote" {
  name             = "knote"
  repository       = "./knote"
  chart            = "knote"
  namespace        = "knote-app"
}

