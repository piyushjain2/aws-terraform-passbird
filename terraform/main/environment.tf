locals {
  env_id     = replace(terraform.workspace, "default", "dev")
  purpose_id = "passbird"
  # AWS Region
  aws_region_map = {
    "dev"  = "ap-south-1"
  }
  aws_region = local.aws_region_map[local.env_id]

  aws_profile_map = {
    "dev"  = "default"
  }
  aws_profile = local.aws_profile_map[local.env_id]

  cidr_prefix_map = {
    "dev"  = "10.1"
  }
  cidr_prefix = local.cidr_prefix_map[local.env_id]

  ami_id_map = {
    "dev"    = "ami-0a3277ffce9146b74"
  }
  ami_id   = local.ami_id_map[local.env_id]

  instance_type_map = {
    "dev"    = "t2.micro"
  }
  instance_type   = local.instance_type_map[local.env_id]
}