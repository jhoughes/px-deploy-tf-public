#px-deploy variables
variable "deployment_name" {
  type        = string
  description = "Name of portworx deployment"
  default     = "vsphere-test"
}

variable "template_name" {
  type        = string
  description = "Name of portworx template"
  default     = "vsphere-test"
}
variable "cluster_count" {
  type        = number
  description = "Number of clusters. Empty by default."
}

variable "node_count" {
  type        = number
  description = "Number of worker nodes. Empty by default."
}

variable "root_user" {
  type        = string
  description = "Root user."
  default     = "root"
}

variable "root_password" {
  type        = string
  description = "Root password"
  default     = "portworx"
  sensitive   = true
}

#vSphere connection variables
variable "vsphere_user" {
  type        = string
  description = "User account for Terraform to sign in to vCenter."
  default     = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type        = string
  description = "Password for Terraform to sign in to vCenter."
  default     = "<my vCenter Server Password>"
  sensitive   = true
}

variable "vsphere_server" {
  type        = string
  description = "vCenter server name."
  default     = "<vCenter Name>"
}

variable "vsphere_insecure" {
  type        = bool
  description = "Allow vSphere self-signed certs"
  default     = "true"
}


#vSphere infrastructure variables
variable "vsphere_datacenter" {
  type        = string
  description = "vSphere datacenter the virtual machine will be deployed to. Empty by default."
}

variable "vsphere_compute_resource" {
  type        = string
  description = "vSphere cluster the virtual machine will be deployed to. Empty by default."
}

variable "vsphere_datastore" {
  type        = string
  description = "vSphere datastore the virtual machine will be deployed to. Empty by default."
}

variable "vsphere_resource_pool" {
  type        = string
  description = "vSphere resource pool the virtual machine will be deployed to. Empty by default."
}

variable "vsphere_network" {
  type        = string
  description = "vSphere network the virtual machine will be attached to. Empty by default."
}

variable "vsphere_virtual_machine_folder" {
  type        = string
  description = "vSphere folder the virtual machine will be placed in. Empty by default."
}

variable "vsphere_template_name" {
  type        = string
  description = "Name of the vSphere template the virtual machine will be deployed from. Empty by default."
}

#VM specific variables
#variable "vsphere_virtual_machine_name" {
#  type        = string
#  description = "Name of the new virtual machine. Empty by default."
#}

variable "vsphere_virtual_machine_cpus" {
  type        = number
  description = "Total number of virtual processor cores for the VM. Empty by default."
}

variable "vsphere_virtual_machine_memory" {
  type        = number
  description = "Total amount of memory for the VM in MB. Empty by default."
}

variable "vsphere_userdata" {
  type        = string
  description = "Userdata passed to the VM. Empty by default."
}
