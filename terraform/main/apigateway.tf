resource "aws_apigatewayv2_api" "pb-gw" {
  name          = "${local.purpose_id}-${local.env_id}-gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_vpc_link" "pb-vpc-link" {
  name               = "example"
  security_group_ids = [aws_security_group.pb-sg-lb.id]
  subnet_ids         = module.vpc.private_subnets
}

resource "aws_apigatewayv2_route" "pb-gw-route" {
  api_id    = aws_apigatewayv2_api.pb-gw.id
  route_key = "ANY /run_on_ec2"

  target = "integrations/${aws_apigatewayv2_integration.pb-gw-int.id}"
}

resource "aws_apigatewayv2_integration" "pb-gw-int" {
  api_id           = aws_apigatewayv2_api.pb-gw.id
  description      = "test with a load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.pb-lb-listener.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.pb-vpc-link.id
}