cidr            = "10.20.0.0/16"
azs             = ["us-east-1a", "us-east-1b"]
private_subnets = ["10.20.1.0/24"]
public_subnets  = ["10.20.101.0/24"]

ecs_service_assign_public_ip = true

atlantis_repo_whitelist = ["github.com/terraform-aws-modules/*"]
atlantis_github_user    = "atlantis-bot"

atlantis_github_user_token = "mygithubpersonalaccesstokenforatlantis"

# Tags
tags = {
  Name = "atlantis"
}
