# vCenter Test

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

locals {
  vcenter_devops_folders = {
    core                   = "Core"
    prod_linux_runner      = "Docker/docker-linux"
    staging                = "Staging/docker-linux"
    windows_staging        = "Staging"
    windows_staging_docker = "Staging/docker-windows"
    unreal_staging         = "Staging/unreal"
    docker                 = "Docker"
  }
}
