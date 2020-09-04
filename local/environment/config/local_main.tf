provider "aws" {
  version = "2.53"
  region  = var.region
}

data "aws_caller_identity" "current" {}

provider "kubernetes" {
  config_context = var.cluster_name
}

provider "helm" {
  version         = "1.1.1"

  kubernetes {
    config_context = var.cluster_name
  }
}

provider "vault" {
  address = var.vault_address

  auth_login {
    path = "auth/aws/login"

    parameters = {
      role                    = "aws-admin"
      iam_http_request_method = "POST"
      iam_request_url         = base64encode("https://sts.amazonaws.com/")
      iam_request_body        = base64encode("Action=GetCallerIdentity&Version=2011-06-15")
      iam_request_headers     = var.iam_caller_identity_headers
    }
  }
}
