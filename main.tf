terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.44.0"
    }
  }

  required_version = "= 1.0.0"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

#tfsec:ignore:AWS079
resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  # skip checks, this is an example project
  # checkov:skip=CKV_AWS_8
  # checkov:skip=CKV_AWS_135
  # checkov:skip=CKV_AWS_126
  # checkov:skip=CKV_AWS_79
  # checkov:skip=CKV2_AWS_17


  tags = {
    Name = "ExampleAppServerInstance"
  }
}
