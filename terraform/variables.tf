
## AWS Provider Configuration

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = ""
}


## VSphere Provider Configuration

variable "vcenter_username" {
  description = "vCenter Login Username"
  type        = string
}

variable "vcenter_password" {
  description = "vCenter Login Password"
  type        = string
}

variable "vcenter_server" {
  description = "vCenter Server Addr"
  type        = string
  default     = ""
}


## VSphere Data

variable "vsphere_datacenter" {
  description = "The vSphere Datacenter Name"
  type        = string
  default     = ""
}

variable "vsphere_datastore" {
  description = "The vSphere Datastore Name"
  type        = string
  default     = ""
}

variable "vsphere_compute_cluster" {
  description = "The vSphere Compute Cluster the VM will start on"
  type        = string
  default     = ""
}

variable "vsphere_network" {
  description = "The VSphere Network the VM will connect to"
  type        = string
  default     = "VM Network"
}
