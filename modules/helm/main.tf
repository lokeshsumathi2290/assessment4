data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "dns" {
  name       = "dns"
  namespace  = "dns"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "external-dns"
  version    = var.helm_dns_version

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "aws.credentials.assumeRoleArn"
    value = var.iam_role_arn
  }

  set {
    name  = "aws.credentials.zoneType"
    value = "var.dns_zone_type"
  }

  set {
    name  = "domainFilters[0]"
    value = var.ingress_domain_name_suffix
  }

  set {
    name  = "rbac.create"
    value = "true"
  }
  depends_on = [var.kubernetes_namespace_dns]
}

resource "helm_release" "public-ingress" {
  name       = "public-ingress"
  namespace  = "ingress"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "nginx-ingress"
  version    = var.helm_ingress_version

  values = [
    "${file("../../modules/helm/public-nginx-ingress.yaml")}"
  ]

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = var.public_ingress_arn
  }
  depends_on = [var.kubernetes_namespace_ingress]
}


resource "helm_release" "internal-ingress" {
  name       = "internal-ingress"
  namespace  = "ingress"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "nginx-ingress"
  version    = var.helm_ingress_version

  values = [
    "${file("../../modules/helm/internal-nginx-ingress.yaml")}"
  ]

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = var.public_ingress_arn
  }
  depends_on = [var.kubernetes_namespace_ingress]
}
