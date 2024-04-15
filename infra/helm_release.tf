provider "helm" {
  kubernetes {
    host                   = module.eks_cluster.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.outputs.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.idp_svc.token
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "v1.14.4"
  values = [
    file("cert-manager-values.yml")
  ]
}

resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "eks/aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "v1.7.2"
  values = [
    file("alb-controller-values.yml")
  ]
  set {
    name  = "clusterName"
    value = local.cluster_name
  }

  depends_on = [
    helm_release.cert_manager
  ]
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns/external-dns"
  namespace  = "external-dns"
  create_namespace = true
  version    = "v1.14.3"
  values = [
    file("external-dns-values.yml")
  ]
  set {
    name  = "txtOwnerId"
    value = var.hosted_zone_id
  }
  set_list {
    name  = "domainFilters"
    value = var.domain_name
  }
  depends_on = [
    helm_release.cert_manager
  ]
}

