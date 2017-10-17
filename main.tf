provider "aws" {
  region = "${var.aws_default_region}"
}

provider "cloudflare" {}

module "global_aws" {
  source         = "modules/_global/aws"
  aws_public_key = "${var.aws_public_key}"
}

module "global_aws_network" {
  source = "modules/_global/aws/network"
}

module "dokku_instance" {
  source = "modules/dokku"

  aws_instance_ami  = "${var.aws_default_ami}"
  aws_instance_type = "${var.aws_default_instance_type}"
  aws_key_name      = "${module.global_aws.aws_key_pair_admin_name}"

  aws_security_group_names = [
    "${module.global_aws_network.aws_security_group_server_name}",
    "${module.global_aws_network.aws_security_group_webserver_name}",
  ]

  domain                = "${var.dokku_domain}"
  subdomain             = "${var.dokku_subdomain}"
  subdomain_test_suffix = "${var.dokku_subdomain_test_suffix}"
}
