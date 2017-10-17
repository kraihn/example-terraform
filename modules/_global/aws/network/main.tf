resource "aws_security_group" "webserver" {
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 443
    protocol  = "tcp"
    to_port   = 443

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "server" {
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

output "aws_security_group_webserver_name" {
  value = "${aws_security_group.webserver.name}"
}

output "aws_security_group_server_name" {
  value = "${aws_security_group.server.name}"
}
