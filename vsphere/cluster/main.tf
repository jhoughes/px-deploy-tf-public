resource "vsphere_virtual_machine" "master" {
  name             = "${var.pass_deployment_name}-master-${var.pass_cluster_index}"
  resource_pool_id = var.pass_resource_pool_id
  datastore_id     = var.pass_datastore_id
  folder           = var.pass_folder
  num_cpus         = var.pass_num_cpus
  memory           = var.pass_memory

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  guest_id  = var.pass_guest_id
  scsi_type = var.pass_scsi_type

  network_interface {
    network_id   = var.pass_network_id
    adapter_type = var.pass_adapter_type
  }

  disk {
    label            = "disk0"
    size             = var.pass_size
    eagerly_scrub    = var.pass_eagerly_scrub
    thin_provisioned = var.pass_thin_provisioned
  }

  clone {
    template_uuid = var.pass_template_uuid
  }

  extra_config = {
    "guestinfo.userdata"          = var.pass_userdata
    "guestinfo.userdata.encoding" = "base64"
  }

  provisioner "file" {
    source      = "../px-deploy/keys/id_rsa.${var.pass_deployment_name}"
    destination = "/tmp/id_rsa/id_rsa.${var.pass_deployment_name}"
  }

}

resource "vsphere_virtual_machine" "worker" {
  count            = var.pass_node_count
  name             = "${var.pass_deployment_name}-worker-${var.pass_cluster_index}-${count.index + 1}"
  resource_pool_id = var.pass_resource_pool_id
  datastore_id     = var.pass_datastore_id
  folder           = var.pass_folder
  num_cpus         = var.pass_num_cpus
  memory           = var.pass_memory

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  guest_id  = var.pass_guest_id
  scsi_type = var.pass_scsi_type

  network_interface {
    network_id   = var.pass_network_id
    adapter_type = var.pass_adapter_type
  }

  disk {
    label            = "disk0"
    size             = var.pass_size
    eagerly_scrub    = var.pass_eagerly_scrub
    thin_provisioned = var.pass_thin_provisioned
  }

  clone {
    template_uuid = var.pass_template_uuid
  }

  connection {
    type     = "ssh"
    agent    = "false"
    host     = "myhost"
    private_key = file("../px-deploy/keys/id_rsa.${var.pass_deployment_name}")
  }

  provisioner "file" {
    source      = "../px-deploy/keys/id_rsa.${var.pass_deployment_name}"
    destination = "/tmp/id_rsa/id_rsa.${var.pass_deployment_name}"
  }

  #provisioner "file" {
  #  source      = "../px-deploy/vagrant/all-common"
  #  destination = "/tmp/all-common"
  #}


  #provisioner "remote-exec" {
  #  script = "/tmp/all-common"
  #}
}
