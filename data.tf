data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}


data "aws_vpc" "default_vpc" {
  id = "vpc-04fb9ac743e2f51f1"
}

data "aws_subnet" "default_subnet_1a" {
  filter {
    name   = "availability-zone"
    values = ["us-east-1a"] # if there are multiple subnets in same az, (from multiple or same vpc, use subnet name
    // if that too fails, use subnet id)
  }
}



data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
