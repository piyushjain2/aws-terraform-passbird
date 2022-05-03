module "vpc" {
  source                = "../modules/aws-vpc"

  env_id                = local.env_id
  purpose_id            = local.purpose_id
  user_id               = data.aws_caller_identity.current.user_id
  aws_region            = local.aws_region
  azs                   = var.azs[local.aws_region]
  cidr_prefix           = local.cidr_prefix
}


module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc.default_security_group_id]

  endpoints = {
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.private_route_table_ids])
      policy          = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
      tags            = { Name = "${local.purpose_id}-dynamodb-vpce" }
    },
  }
}

