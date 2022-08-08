provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

data "aws_ami" "px_deploy_centos" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
resource "aws_key_pair" "px_deploy_key" {
  key_name   = "px-deploy.${var.deployment_name}"
  public_key = file("../px-deploy/keys/id_rsa.aws.${var.deployment_name}.pub")
}

resource "aws_vpc" "px_deploy_vpc" {
  cidr_block       = var.aws_vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    px-deploy_name = "${var.deployment_name}"
    Name           = "px-deploy.${var.deployment_name}"
  }

}

resource "aws_subnet" "px_deploy_subnet" {
  vpc_id     = aws_vpc.px_deploy_vpc.id
  cidr_block = var.aws_vpc_cidr_block
  tags = {
    px-deploy_name = "${var.deployment_name}"
  }

}

resource "aws_internet_gateway" "px_deploy_gw" {
  vpc_id = aws_vpc.px_deploy_vpc.id

  tags = {
    px-deploy_name = "${var.deployment_name}"
  }

}

resource "aws_route_table" "px_deploy_routetable" {
  vpc_id = aws_vpc.px_deploy_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.px_deploy_gw.id
  }

  tags = {
    px-deploy_name = "${var.deployment_name}"
  }

}

resource "aws_route_table_association" "px_deploy_routeassoc" {
  subnet_id      = aws_subnet.px_deploy_subnet.id
  route_table_id = aws_route_table.px_deploy_routetable.id
}

resource "aws_security_group" "px_deploy_sg" {
  name        = var.aws_sec_group_name
  description = "Security group for px-deploy"
  vpc_id      = aws_vpc.px_deploy_vpc.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2382
    protocol    = "tcp"
    to_port     = 2382
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5900
    protocol    = "tcp"
    to_port     = 5900
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    protocol    = "tcp"
    to_port     = 8443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    protocol    = "tcp"
    to_port     = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    protocol    = "all"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.0.0/16"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    px-deploy_name = "${var.deployment_name}"
  }

}

module "cluster" {
  count  = var.cluster_count
  source = "./cluster"

  pass_deployment_name = var.deployment_name
  pass_node_count      = var.node_count

  pass_ami           = data.aws_ami.px_deploy_centos.id
  pass_instance_type = var.aws_instance_type
  pass_subnet_id     = aws_subnet.px_deploy_subnet.id
  pass_public_ip     = var.aws_public_ip
  pass_aws_ebs       = var.aws_ebs
  pass_cluster_index = count.index + 1

  pass_security_group_id = [
    "${aws_security_group.px_deploy_sg.id}"
  ]

  depends_on = [aws_security_group.px_deploy_sg]

}

