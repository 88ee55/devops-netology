# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

locals {
  web_instance_type_map = {
    stage = "t2.nano"
    prod = "t2.micro"
  }
  web_instance_count_map = {
    stage = 1
    prod = 2
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  count = local.web_instance_count_map[terraform.workspace]

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }
}

resource "aws_instance" "back" {
  for_each = { for i in range(0, local.web_instance_count_map[terraform.workspace]) : i => i }
  ami = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]

  lifecycle {
    create_before_destroy = true
  }
}


data "aws_caller_identity" "current" {}

data "aws_region" "current" {}