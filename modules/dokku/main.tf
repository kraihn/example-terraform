variable "aws_instance_ami" {}
variable "aws_instance_type" {}
variable "aws_key_name" {}

variable "aws_security_group_names" {
  type = "list"
}

variable "domain" {}
variable "subdomain" {}
variable "subdomain_test_suffix" {}

resource "aws_instance" "host" {
  ami                         = "${var.aws_instance_ami}"
  instance_type               = "${var.aws_instance_type}"
  key_name                    = "${var.aws_key_name}"
  associate_public_ip_address = true

  security_groups = ["${var.aws_security_group_names}"]
}

resource "cloudflare_record" "hostname" {
  domain = "${var.domain}"
  name   = "${var.subdomain}${var.subdomain_test_suffix}"
  type   = "A"
  value  = "${aws_instance.host.public_ip}"
}

resource "cloudflare_record" "wildcard" {
  domain = "${var.domain}"
  name   = "*.${var.subdomain}${var.subdomain_test_suffix}"
  type   = "CNAME"
  value  = "${cloudflare_record.hostname.hostname}"
}
