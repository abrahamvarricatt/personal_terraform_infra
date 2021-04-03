cidr            = "10.10.0.0/16"
azs             = ["us-east-1a", "us-east-1b"]
private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
public_subnets  = ["10.10.11.0/24", "10.10.12.0/24"]

# Tags
tags = {
  Name = "atlantis"
}