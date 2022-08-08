#px-deploy variables
variable "deployment_name" {
  type        = string
  description = "Name of portworx deployment"
  default     = "aws-test"
}

variable "cluster_count" {
  type        = number
  description = "Number of Portworx clusters"
}

variable "node_count" {
  type        = number
  description = "Number of Portworx nodes"
}

#AWS Account variables
variable "aws_access_key_id" {
  type        = string
  description = "AWS access key. Empty by default."
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS secret key. Empty by default."
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS region. Empty by default."
}

#AWS EC2 variables
variable "aws_instance_type" {
  type        = string
  description = "AWS instance type. Empty by default."
}

variable "aws_vpc_cidr_block" {
  type        = string
  description = "AWS VPC CIDR block. Empty by default."
}

variable "aws_sec_group_name" {
  type        = string
  description = "AWS security group name. Empty by default."
}

variable "aws_public_ip" {
  type        = bool
  description = "Associate with an AWS public IP. Empty by default."
}

variable "aws_ebs" {
  type        = string
  description = "Array of EBS volumes to attach, single volume by default."
}

variable "aws_tags" {
  type        = string
  description = "Array of AWS tags, empty by default."
}