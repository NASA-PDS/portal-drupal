provider "aws" {
  region = var.aws_region
}

# Fetch the default VPC and subnet to keep things simple
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

