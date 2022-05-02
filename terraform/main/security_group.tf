resource "aws_security_group" "pb-sg-instance" {
  name = "${local.purpose_id}-${local.env_id}-instance-sg"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.pb-sg-lb.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.pb-sg-lb.id]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "pb-sg-lb" {
  name = "${local.purpose_id}-${local.env_id}-lb-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}