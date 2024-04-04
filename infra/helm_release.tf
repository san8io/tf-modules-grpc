provider "helm" {
  kubernetes {
    host                   = module.eks_simetrik.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_simetrik.outputs.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.idp_svc.token
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "v1.12.0"
  values = [
    file("${path.module}/cert-manager-values.yaml")
  ]
}
