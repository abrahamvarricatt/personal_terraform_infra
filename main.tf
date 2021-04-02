terraform {
  required_version = "0.14.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "disabled"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "ExampleInstance"
  }
}

