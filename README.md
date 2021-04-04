# personal_terraform_infra

Lets see how terraform docs shows stuff,



<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 0.14.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | = 3.27 |
| <a name="requirement_random"></a> [random](#requirement\_random) | = 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | = 3.27 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | v5.10.0 |
| <a name="module_alb_http_sg"></a> [alb\_http\_sg](#module\_alb\_http\_sg) | terraform-aws-modules/security-group/aws//modules/http-80 | v3.17.0 |
| <a name="module_alb_https_sg"></a> [alb\_https\_sg](#module\_alb\_https\_sg) | terraform-aws-modules/security-group/aws//modules/https-443 | v3.17.0 |
| <a name="module_container_definition_github_gitlab"></a> [container\_definition\_github\_gitlab](#module\_container\_definition\_github\_gitlab) | cloudposse/ecs-container-definition/aws | v0.45.2 |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | terraform-aws-modules/ecs/aws | v2.5.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | v2.64.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.atlantis](https://registry.terraform.io/providers/hashicorp/aws/3.27/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_task_definition.atlantis](https://registry.terraform.io/providers/hashicorp/aws/3.27/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/3.27/docs/resources/iam_role) | resource |
| [aws_iam_policy_document.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/3.27/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.27/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/3.27/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_http_security_group_tags"></a> [alb\_http\_security\_group\_tags](#input\_alb\_http\_security\_group\_tags) | Additional tags to put on the http security group | `map(string)` | `{}` | no |
| <a name="input_alb_https_security_group_tags"></a> [alb\_https\_security\_group\_tags](#input\_alb\_https\_security\_group\_tags) | Additional tags to put on the https security group | `map(string)` | `{}` | no |
| <a name="input_alb_ingress_cidr_blocks"></a> [alb\_ingress\_cidr\_blocks](#input\_alb\_ingress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all ingress rules of the ALB. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_alb_listener_ssl_policy_default"></a> [alb\_listener\_ssl\_policy\_default](#input\_alb\_listener\_ssl\_policy\_default) | The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html). | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_alb_log_bucket_name"></a> [alb\_log\_bucket\_name](#input\_alb\_log\_bucket\_name) | S3 bucket (externally created) for storing load balancer access logs. Required if alb\_logging\_enabled is true. | `string` | `""` | no |
| <a name="input_alb_log_location_prefix"></a> [alb\_log\_location\_prefix](#input\_alb\_log\_location\_prefix) | S3 prefix within the log\_bucket\_name under which logs are stored. | `string` | `""` | no |
| <a name="input_alb_logging_enabled"></a> [alb\_logging\_enabled](#input\_alb\_logging\_enabled) | Controls if the ALB will log requests to S3. | `bool` | `false` | no |
| <a name="input_allow_repo_config"></a> [allow\_repo\_config](#input\_allow\_repo\_config) | When true allows the use of atlantis.yaml config files within the source repos. | `string` | `"false"` | no |
| <a name="input_atlantis_github_user"></a> [atlantis\_github\_user](#input\_atlantis\_github\_user) | GitHub username that is running the Atlantis command | `string` | `""` | no |
| <a name="input_atlantis_github_user_token"></a> [atlantis\_github\_user\_token](#input\_atlantis\_github\_user\_token) | GitHub token of the user that is running the Atlantis command | `string` | `""` | no |
| <a name="input_atlantis_github_user_token_ssm_parameter_name"></a> [atlantis\_github\_user\_token\_ssm\_parameter\_name](#input\_atlantis\_github\_user\_token\_ssm\_parameter\_name) | Name of SSM parameter to keep atlantis\_github\_user\_token | `string` | `"/atlantis/github/user/token"` | no |
| <a name="input_atlantis_github_webhook_secret"></a> [atlantis\_github\_webhook\_secret](#input\_atlantis\_github\_webhook\_secret) | GitHub webhook secret of an app that is running the Atlantis command | `string` | `""` | no |
| <a name="input_atlantis_hide_prev_plan_comments"></a> [atlantis\_hide\_prev\_plan\_comments](#input\_atlantis\_hide\_prev\_plan\_comments) | Enables atlantis server --hide-prev-plan-comments hiding previous plan comments on update | `string` | `"false"` | no |
| <a name="input_atlantis_log_level"></a> [atlantis\_log\_level](#input\_atlantis\_log\_level) | Log level that Atlantis will run with. Accepted values are: <debug\|info\|warn\|error> | `string` | `"debug"` | no |
| <a name="input_atlantis_port"></a> [atlantis\_port](#input\_atlantis\_port) | Local port Atlantis should be running on. Default value is most likely fine. | `number` | `4141` | no |
| <a name="input_atlantis_repo_whitelist"></a> [atlantis\_repo\_whitelist](#input\_atlantis\_repo\_whitelist) | List of allowed repositories Atlantis can be used with | `list(string)` | n/a | yes |
| <a name="input_atlantis_version"></a> [atlantis\_version](#input\_atlantis\_version) | Verion of Atlantis to run. If not specified latest will be used | `string` | `"latest"` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | A list of availability zones in the region | `list(string)` | `[]` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR block for the VPC which will be created if `vpc_id` is not specified | `string` | `""` | no |
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | Retention period of Atlantis CloudWatch logs | `number` | `7` | no |
| <a name="input_container_memory_reservation"></a> [container\_memory\_reservation](#input\_container\_memory\_reservation) | The amount of memory (in MiB) to reserve for the container | `number` | `128` | no |
| <a name="input_create_route53_record"></a> [create\_route53\_record](#input\_create\_route53\_record) | Whether to create Route53 record for Atlantis | `bool` | `false` | no |
| <a name="input_custom_container_definitions"></a> [custom\_container\_definitions](#input\_custom\_container\_definitions) | A list of valid container definitions provided as a single valid JSON document. By default, the standard container definition is used. | `string` | `""` | no |
| <a name="input_custom_environment_secrets"></a> [custom\_environment\_secrets](#input\_custom\_environment\_secrets) | List of additional secrets the container will use (list should contain maps with `name` and `valueFrom`) | <pre>list(object(<br>    {<br>      name      = string<br>      valueFrom = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_custom_environment_variables"></a> [custom\_environment\_variables](#input\_custom\_environment\_variables) | List of additional environment variables the container will use (list should contain maps with `name` and `value`) | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | The number of cpu units used by the task | `number` | `256` | no |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | The amount (in MiB) of memory used by the task | `number` | `512` | no |
| <a name="input_extra_container_definitions"></a> [extra\_container\_definitions](#input\_extra\_container\_definitions) | A list of valid container definitions provided as a single valid JSON document. These will be provided as supplimentary to the main Atlantis container definition | `list(any)` | `[]` | no |
| <a name="input_firelens_configuration"></a> [firelens\_configuration](#input\_firelens\_configuration) | The FireLens configuration for the container. This is used to specify and configure a log router for container logs. For more details, see https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_FirelensConfiguration.html | <pre>object({<br>    type    = string<br>    options = map(string)<br>  })</pre> | `null` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Whether the load balancer is internal or external | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to use on all resources created (VPC, ALB, etc) | `string` | `"atlantis"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | If provided, all IAM roles will be created with this permissions boundary attached. | `string` | `null` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | `"us-east-1"` | no |
| <a name="input_repository_credentials"></a> [repository\_credentials](#input\_repository\_credentials) | Container repository credentials; required when using a private repo.  This map currently supports a single key; "credentialsParameter", which should be the ARN of a Secrets Manager's secret holding the credentials | `map(string)` | `null` | no |
| <a name="input_route53_record_name"></a> [route53\_record\_name](#input\_route53\_record\_name) | Name of Route53 record to create ACM certificate in and main A-record. If null is specified, var.name is used instead. Provide empty string to point root domain name to ALB. | `string` | `null` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Route53 zone name to create ACM certificate in and main A-record, without trailing dot | `string` | `""` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of one or more security groups to be added to the load balancer | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to use on all resources | `map(string)` | `{}` | no |
| <a name="input_trusted_principals"></a> [trusted\_principals](#input\_trusted\_principals) | A list of principals, in addition to ecs-tasks.amazonaws.com, that can assume the task role | `list(string)` | `[]` | no |
| <a name="input_ulimits"></a> [ulimits](#input\_ulimits) | Container ulimit settings. This is a list of maps, where each map should contain "name", "hardLimit" and "softLimit" | <pre>list(object({<br>    name      = string<br>    hardLimit = number<br>    softLimit = number<br>  }))</pre> | `null` | no |
| <a name="input_user"></a> [user](#input\_user) | The user to run as inside the container. Can be any of these formats: user, user:group, uid, uid:gid, user:gid, uid:group. The default (null) will use the container's configured `USER` directive or root if not set. | `string` | `null` | no |
| <a name="input_webhook_ssm_parameter_name"></a> [webhook\_ssm\_parameter\_name](#input\_webhook\_ssm\_parameter\_name) | Name of SSM parameter to keep webhook secret | `string` | `"/atlantis/webhook/secret"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
