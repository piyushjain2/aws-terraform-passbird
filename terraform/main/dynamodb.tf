resource "aws_dynamodb_table" "dynamodb_random" {
  name         = "${local.env_id}-random"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = local.env_id
    CreatedBy   = "Terraform"
  }
}