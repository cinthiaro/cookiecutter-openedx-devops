#------------------------------------------------------------------------------
# written by: Lawrence McDaniel
#             https://lawrencemcdaniel.com/
#
# date: Feb-2023
#
# usage: Wordpress ssl certs for ingress
#------------------------------------------------------------------------------

data "template_file" "cluster-issuer" {
  template = file("${path.module}/config/cluster-issuer.yml.tpl")
  vars = {
    root_domain      = local.wordpressRootDomain
    wordpress_domain = local.wordpressDomain
    aws_region       = var.aws_region
    hosted_zone_id   = data.aws_route53_zone.wordpress_domain.id
  }
}

resource "kubernetes_manifest" "cluster-issuer" {
  manifest = yamldecode(data.template_file.cluster-issuer.rendered)

  depends_on = [
    kubernetes_namespace.wordpress,
    helm_release.wordpress
  ]
}
