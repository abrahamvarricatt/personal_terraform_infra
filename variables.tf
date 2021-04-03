variable "name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type        = string
  default     = "atlantis"
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

variable "cidr" {
  description = "The CIDR block for the VPC which will be created if `vpc_id` is not specified"
  type        = string
  default     = ""
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "internal" {
  description = "Whether the load balancer is internal or external"
  type        = bool
  default     = false
}

# ALB
variable "alb_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_https_security_group_tags" {
  description = "Additional tags to put on the https security group"
  type        = map(string)
  default     = {}
}

variable "alb_http_security_group_tags" {
  description = "Additional tags to put on the http security group"
  type        = map(string)
  default     = {}
}

variable "security_group_ids" {
  description = "List of one or more security groups to be added to the load balancer"
  type        = list(string)
  default     = []
}

variable "alb_log_bucket_name" {
  description = "S3 bucket (externally created) for storing load balancer access logs. Required if alb_logging_enabled is true."
  type        = string
  default     = ""
}

variable "alb_log_location_prefix" {
  description = "S3 prefix within the log_bucket_name under which logs are stored."
  type        = string
  default     = ""
}

variable "alb_logging_enabled" {
  description = "Controls if the ALB will log requests to S3."
  type        = bool
  default     = false
}

variable "alb_listener_ssl_policy_default" {
  description = "The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html)."
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "atlantis_port" {
  description = "Local port Atlantis should be running on. Default value is most likely fine."
  type        = number
  default     = 4141
}


# Route53
variable "route53_zone_name" {
  description = "Route53 zone name to create ACM certificate in and main A-record, without trailing dot"
  type        = string
  default     = ""
}

variable "route53_record_name" {
  description = "Name of Route53 record to create ACM certificate in and main A-record. If null is specified, var.name is used instead. Provide empty string to point root domain name to ALB."
  type        = string
  default     = null
}

variable "create_route53_record" {
  description = "Whether to create Route53 record for Atlantis"
  type        = bool
  default     = false
}
