provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-08d70e59c07c61a3a"
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

