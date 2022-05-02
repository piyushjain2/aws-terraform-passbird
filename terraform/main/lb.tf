resource "aws_lb" "pb-lb" {
  name               = "${local.purpose_id}-${local.env_id}-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pb-sg-lb.id]
  subnets            = module.vpc.private_subnets
}

resource "aws_lb_listener" "pb-lb-listener" {
  load_balancer_arn = aws_lb.pb-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code = "200"
    }
  }
}

resource "aws_lb_listener_rule" "pb-lb-rule" {
  listener_arn = aws_lb_listener.pb-lb-listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pb-tg.arn
  }

  condition {
    path_pattern {
      values = ["/run_on_ec2/*"]
    }
  }
}

resource "aws_lb_target_group" "pb-tg" {
  name     = "${local.purpose_id}-${local.env_id}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}