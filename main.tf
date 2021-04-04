locals {
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  public_subnet_ids  = module.vpc.public_subnets

  atlantis_image = "runatlantis/atlantis:${var.atlantis_version}"

  atlantis_url = "http://figure-out-later"

  # Container definitions
  container_definitions = var.custom_container_definitions == "" ? jsonencode(concat([module.container_definition_github_gitlab.json_map_object], var.extra_container_definitions)) : var.custom_container_definitions

  container_definition_environment = [
    {
      name  = "ATLANTIS_ALLOW_REPO_CONFIG"
      value = var.allow_repo_config
    },
    {
      name  = "ATLANTIS_LOG_LEVEL"
      value = var.atlantis_log_level
    },
    {
      name  = "ATLANTIS_PORT"
      value = var.atlantis_port
    },
    {
      name  = "ATLANTIS_ATLANTIS_URL"
      value = local.atlantis_url
    },
    {
      name  = "ATLANTIS_GH_USER"
      value = var.atlantis_github_user
    },
    {
      name  = "ATLANTIS_REPO_WHITELIST"
      value = join(",", var.atlantis_repo_whitelist)
    },
    {
      name  = "ATLANTIS_HIDE_PREV_PLAN_COMMENTS"
      value = var.atlantis_hide_prev_plan_comments
    },
  ]

  # Include only one group of secrets - for github, gitlab or bitbucket
  has_secrets = var.atlantis_github_user_token != ""

  # token
  secret_name_key        = "ATLANTIS_GH_TOKEN"                               #tfsec:ignore:GEN002
  secret_name_value_from = var.atlantis_github_user_token_ssm_parameter_name #tfsec:ignore:GEN002

  # webhook
  secret_webhook_key = "ATLANTIS_GH_WEBHOOK_SECRET" #tfsec:ignore:GEN002


  # Secret access tokens
  container_definition_secrets_1 = local.secret_name_key != "" && local.secret_name_value_from != "" ? [
    {
      name      = local.secret_name_key
      valueFrom = local.secret_name_value_from
    },
  ] : []

  # Webhook secrets are not supported by BitBucket
  container_definition_secrets_2 = local.secret_webhook_key != "" ? [
    {
      name      = local.secret_webhook_key
      valueFrom = var.webhook_ssm_parameter_name
    },
  ] : []

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

data "aws_region" "current" {}


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
# module "acm" {
#  source  = "terraform-aws-modules/acm/aws"
#  version = "v2.12.0"

#  create_certificate = true

#  domain_name = "" # join(".", [var.name, var.route53_zone_name])
#
#  zone_id = element(concat(data.aws_route53_zone.this.*.id, [""]), 0)

#  tags = local.tags
# }

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

  http_tcp_listeners = [
    {
      target_group_index = 0
      port               = 80
      protocol           = "HTTP"
      action_type        = "forward"
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

###################
# ECS
###################
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "v2.5.0"

  name               = var.name
  container_insights = false

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy = {
    capacity_provider = "FARGATE"
  }

  tags = local.tags
}

module "container_definition_github_gitlab" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "v0.45.2"

  container_name  = var.name
  container_image = local.atlantis_image

  container_cpu                = var.ecs_task_cpu
  container_memory             = var.ecs_task_memory
  container_memory_reservation = var.container_memory_reservation

  user                     = var.user
  ulimits                  = var.ulimits
  entrypoint               = null
  command                  = null
  working_directory        = null
  repository_credentials   = var.repository_credentials
  docker_labels            = null
  start_timeout            = 30
  stop_timeout             = 30
  container_depends_on     = null
  essential                = true
  readonly_root_filesystem = false
  mount_points             = []
  volumes_from             = []

  port_mappings = [
    {
      containerPort = var.atlantis_port
      hostPort      = var.atlantis_port
      protocol      = "tcp"
    },
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-region        = data.aws_region.current.name
      awslogs-group         = aws_cloudwatch_log_group.atlantis.name
      awslogs-stream-prefix = "ecs"
    }
    secretOptions = []
  }
  firelens_configuration = var.firelens_configuration

  environment = concat(
    local.container_definition_environment,
    var.custom_environment_variables,
  )

  secrets = concat(
    local.container_definition_secrets_1,
    local.container_definition_secrets_2,
    var.custom_environment_secrets,
  )
}

###################
# Cloudwatch logs
###################
resource "aws_cloudwatch_log_group" "atlantis" {
  name              = var.name
  retention_in_days = var.cloudwatch_log_retention_in_days

  tags = local.tags
}




data "aws_iam_policy_document" "ecs_tasks" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = compact(distinct(concat(["ecs-tasks.amazonaws.com"], var.trusted_principals)))
    }
  }
}


resource "aws_iam_role" "ecs_task_execution" {
  name                 = "${var.name}-ecs_task_execution"
  assume_role_policy   = data.aws_iam_policy_document.ecs_tasks.json
  permissions_boundary = var.permissions_boundary

  tags = local.tags
}


resource "aws_ecs_task_definition" "atlantis" {
  family                   = var.name
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_execution.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  container_definitions = local.container_definitions

  tags = local.tags
}
