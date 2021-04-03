locals {
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  public_subnet_ids  = module.vpc.public_subnets

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}

data "aws_route53_zone" "this" {
  count = var.create_route53_record ? 1 : 0

  name         = var.route53_zone_name
  private_zone = false
}

provider "aws" {
  region = var.region
}


###################
# VPC
###################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v2.64.0"

  create_vpc = true

  name = var.name

  cidr            = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

###################
# Security groups
###################
module "alb_https_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "v3.17.0"

  name        = "${var.name}-alb-https"
  vpc_id      = local.vpc_id
  description = "Security group with HTTPS ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = sort(compact(var.alb_ingress_cidr_blocks)) #tfsec:ignore:AWS006

  tags = merge(local.tags, var.alb_https_security_group_tags)
}

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "v3.17.0"

  name        = "${var.name}-alb-http"
  vpc_id      = local.vpc_id
  description = "Security group with HTTP ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = sort(compact(var.alb_ingress_cidr_blocks)) #tfsec:ignore:AWS006

  tags = merge(local.tags, var.alb_http_security_group_tags)
}

###################
# ACM (SSL certificate)
###################
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "v2.12.0"

  create_certificate = true

  domain_name = "" # join(".", [var.name, var.route53_zone_name])

  zone_id = element(concat(data.aws_route53_zone.this.*.id, [""]), 0)

  tags = local.tags
}

###################
# ALB
###################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "v5.10.0"

  name     = var.name
  internal = var.internal

  vpc_id          = local.vpc_id
  subnets         = local.public_subnet_ids
  security_groups = flatten([module.alb_https_sg.this_security_group_id, module.alb_http_sg.this_security_group_id, var.security_group_ids])

  access_logs = {
    enabled = var.alb_logging_enabled
    bucket  = var.alb_log_bucket_name
    prefix  = var.alb_log_location_prefix
  }

  listener_ssl_policy_default = var.alb_listener_ssl_policy_default
  https_listeners = [
    {
      target_group_index = 0
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.this_acm_certificate_arn
      action_type        = "forward"
    },
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = 443
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]

  target_groups = [
    {
      name                 = var.name
      backend_protocol     = "HTTP"
      backend_port         = var.atlantis_port
      target_type          = "ip"
      deregistration_delay = 10
    },
  ]

  tags = local.tags
}
