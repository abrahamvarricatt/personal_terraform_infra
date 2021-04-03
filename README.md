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
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | v2.12.0 |
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | v5.10.0 |
| <a name="module_alb_http_sg"></a> [alb\_http\_sg](#module\_alb\_http\_sg) | terraform-aws-modules/security-group/aws//modules/http-80 | v3.17.0 |
| <a name="module_alb_https_sg"></a> [alb\_https\_sg](#module\_alb\_https\_sg) | terraform-aws-modules/security-group/aws//modules/https-443 | v3.17.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | v2.64.0 |

## Resources

| Name | Type |
|------|------|
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
| <a name="input_atlantis_port"></a> [atlantis\_port](#input\_atlantis\_port) | Local port Atlantis should be running on. Default value is most likely fine. | `number` | `4141` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | A list of availability zones in the region | `list(string)` | `[]` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR block for the VPC which will be created if `vpc_id` is not specified | `string` | `""` | no |
| <a name="input_create_route53_record"></a> [create\_route53\_record](#input\_create\_route53\_record) | Whether to create Route53 record for Atlantis | `bool` | `false` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Whether the load balancer is internal or external | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to use on all resources created (VPC, ALB, etc) | `string` | `"atlantis"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources will be created | `string` | `"us-east-1"` | no |
| <a name="input_route53_record_name"></a> [route53\_record\_name](#input\_route53\_record\_name) | Name of Route53 record to create ACM certificate in and main A-record. If null is specified, var.name is used instead. Provide empty string to point root domain name to ALB. | `string` | `null` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Route53 zone name to create ACM certificate in and main A-record, without trailing dot | `string` | `""` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of one or more security groups to be added to the load balancer | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to use on all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
