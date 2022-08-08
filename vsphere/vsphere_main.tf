terraform {
  backend "local" {}
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.vsphere_insecure
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_compute_resource
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "cluster" {
  count  = var.cluster_count
  source = "./cluster"

  #
  pass_deployment_name = var.deployment_name
  pass_node_count      = var.node_count
  pass_cluster_index   = count.index + 1

  pass_resource_pool_id = data.vsphere_resource_pool.pool.id
  pass_datastore_id     = data.vsphere_datastore.datastore.id
  pass_folder           = var.vsphere_virtual_machine_folder
  pass_num_cpus         = var.vsphere_virtual_machine_cpus
  pass_memory           = var.vsphere_virtual_machine_memory

  pass_guest_id  = data.vsphere_virtual_machine.template.guest_id
  pass_scsi_type = data.vsphere_virtual_machine.template.scsi_type

  pass_network_id   = data.vsphere_network.network.id
  pass_adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]

  pass_size             = data.vsphere_virtual_machine.template.disks.0.size
  pass_eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
  pass_thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned

  pass_template_uuid = data.vsphere_virtual_machine.template.id
  pass_userdata      = var.vsphere_userdata

}
