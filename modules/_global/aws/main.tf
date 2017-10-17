variable "aws_public_key" {}

resource "aws_key_pair" "admin" {
  public_key = "${var.aws_public_key}"
}

output "aws_key_pair_admin_name" {
  value = "${aws_key_pair.admin.key_name}"
}
