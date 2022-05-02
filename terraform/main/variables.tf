variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "azs" {
  type        = map(list(string))
  description = "Availability zones by region"
  default = {
    us-east-1      = ["us-east-1a", "us-east-1b", "us-east-1c"]
    us-west-1      = ["us-west-1a", "us-west-1b"]
    ap-south-1     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
    ap-southeast-1 = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  }
}