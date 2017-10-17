variable "aws_public_key" {}

variable "aws_default_ami" {
  default = "ami-ac5e55d7"
}

variable "aws_default_instance_type" {
  default = "t2.micro"
}

variable "aws_default_region" {
  default = "us-east-1"
}

variable "dokku_domain" {}

variable "dokku_subdomain" {
  default = "apps"
}

variable "dokku_subdomain_test_suffix" {
  default = ""
}
