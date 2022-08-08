locals {
  sec_group_id = var.pass_security_group_id
  each_ebs = split(" ", var.pass_aws_ebs)
}


resource "aws_instance" "master" {
  ami                         = var.pass_ami
  instance_type               = var.pass_instance_type
  subnet_id                   = var.pass_subnet_id
  associate_public_ip_address = var.pass_public_ip
  key_name                    = "px-deploy.${var.pass_deployment_name}"

  tags = {
    Name = "master-${var.pass_cluster_index}",
    ClusterRole = "master"
  }

  vpc_security_group_ids = [
    var.pass_security_group_id[0]
  ]
  root_block_device {
    delete_on_termination = true
    volume_size           = split(":",(split(" ", var.pass_aws_ebs)[0]))[1]
    volume_type           = split(":",(split(" ", var.pass_aws_ebs)[0]))[0]
  }

#  depends_on = [aws_security_group.px_deploy_sg]
}

#resource "aws_ebs_volume" "master_ebs" {
#  availability_zone = aws_instance.master.availability_zone
#  size              = 50
#}
#
#resource "aws_volume_attachment" "master_attach" {
#  device_name = "/dev/sda1"
#  volume_id   = aws_ebs_volume.master_ebs.id
#  instance_id = aws_instance.master.id
#}


resource "aws_instance" "worker" {
  count                       = var.pass_node_count
  ami                         = var.pass_ami
  instance_type               = var.pass_instance_type
  subnet_id                   = var.pass_subnet_id
  associate_public_ip_address = var.pass_public_ip
  key_name                    = "px-deploy.${var.pass_deployment_name}"

  tags = {
    Name = "worker-${var.pass_cluster_index}-${count.index + 1}",
    ClusterRole = "worker"
  }
  vpc_security_group_ids = [
    var.pass_security_group_id[0]
  ]

  root_block_device {
    delete_on_termination = true
    volume_size = split(":",(split(" ", var.pass_aws_ebs)[0]))[1]
    volume_type = split(":",(split(" ", var.pass_aws_ebs)[0]))[0]
  }

#  depends_on = [aws_security_group.px_deploy_sg]
}

#resource "aws_ebs_volume" "worker_ebs" {
#  count             = var.node_count
#  availability_zone = aws_instance.worker.*.availability_zone[count.index]
#  size              = 50
#}
#
#resource "aws_volume_attachment" "worker_attach" {
#  count       = var.node_count
#  device_name = "/dev/sda1"
#  volume_id   = aws_ebs_volume.worker_ebs.*.id[count.index]
#  instance_id = aws_instance.worker.*.id[count.index]
#}

