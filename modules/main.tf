data "aws_route53_zone" "primary" {
  name         = "*.com.in."
}

resource "aws_security_group" "wordpress-blog-sg" {
  name        = "wordpress-blog-sg-allow_tls"
  description = "Allow TLS, HTTPS, inbound traffic"

  ingress {
    description = "SSH from Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow tls and ssh"
  }
}

resource "aws_key_pair" "wordpress-key" {
  key_name   = "wordpress-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDm2pDvf2XzCiA1aS5/RolaEKE3gUcezLauVk3Q8UXWZ+nOYWhoF9YORiSrziToU9+eLBkkvMJCGkD8Lpniimzt3Dv23Py7zljTfkRx79B102Kt/RfSEaevxE0WQtaSv5g74YENr+HmK1KRlwb7oxa2Bng9wgti7tLL+UOU3g5TsgNXpY8twgNrUSHXMAlRr4Hm3/dMcDMSdjMEXdx9rrYtMEIxeJsBQX4nABPBSln5hjz9ymN315Q0dWtLgs5zxzDZ5jK9BaJ7kVhGBqKgblLYwnBOvsKoQcxlJ3uuU9HBhboNHxUbtPuyHwxA3rZtt2Xb6457ISEEqBO6vdm+/vBp sree@Srees-MacBook-Air.local"
}

resource "aws_instance" "wordpress-blog" {
  ami           = "ami-0b521c4e21ea9a9f1"
  instance_type = "t3a.small"
  security_groups = ["${aws_security_group.wordpress-blog-sg.name}"]

  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
  associate_public_ip_address          = true

  key_name = aws_key_pair.wordpress-key.key_name


  tags = {
    Environment = var.environment
    Project     = var.project_name
    Name        = "${var.environment}-${var.project_name}-wordpress-blog"
  }
}

resource "aws_route53_record" "wordpress-blog-primary-record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "blog.${data.aws_route53_zone.primary.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.wordpress-blog.public_ip}"]
}

resource "aws_route53_record" "wordpress-blog-secondary-record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "www.blog.${data.aws_route53_zone.primary.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.wordpress-blog.public_ip}"]
}
