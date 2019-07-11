data "template_file" "issuer_values" {
  template = "${file("${path.module}/issuer-values.tpl")}"

  vars = {
    issuer_name                 = "${var.issuer_name}"
    issuer_type                 = "${var.issuer_type}"
    provider_http_enabled       = "${var.provider_http_enabled}"
    provider_http_ingress_class = "${var.provider_http_ingress_class}"
    provider_dns_enabled        = "${var.provider_dns_enabled}"
    provider_dns_name           = "${var.provider_dns_name}"
    provider_dns_type           = "${var.provider_dns_type}"
    provider_dns_region         = "${var.provider_dns_region}"
    provider_dns_hosted_zone    = "${var.provider_dns_hosted_zone}"
    crd_waiter                  = "${var.crd_waiter}"                  # this enforces a dependency on the cert-manager CRDs
  }
}

resource "helm_release" "cert_manager_issuers" {
  name      = "cert-manager-issuers-${var.namespace}"
  namespace = "${var.namespace}"
  chart     = ".${replace(path.module, path.root, "")}/helm/cert-manager-issuers"
  timeout   = 600
  wait      = true

  values = ["${data.template_file.issuer_values.rendered}"]
}
