
data "vsphere_virtual_machine" "minio_ubuntu_template" {
  name          = "linux-ubuntu-22.04-lts-0.0.3"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

locals {
  minio_vm_hostname  = "storage-minio-01"
  minio_vm_cpus      = "4"
  minio_vm_memory    = "16384"
  minio_vm_disk_size = "1000"
}

resource "vsphere_virtual_machine" "minio_core" {

  name             = local.minio_vm_hostname
  folder           = local.vcenter_devops_folders.core
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = local.minio_vm_cpus
  memory           = local.minio_vm_memory
  guest_id         = "ubuntu64Guest"
  firmware         = data.vsphere_virtual_machine.minio_ubuntu_template.firmware

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  wait_for_guest_net_timeout = 5
  wait_for_guest_ip_timeout  = 5

  disk {
    label            = "${local.minio_vm_hostname}-disk"
    thin_provisioned = data.vsphere_virtual_machine.minio_ubuntu_template.disks[0].thin_provisioned
    size             = local.minio_vm_disk_size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.minio_ubuntu_template.id
    customize {
      linux_options {
        host_name = local.minio_vm_hostname
        domain    = ""
      }
      network_interface {
      }
    }
  }

  // workaround for an issue with terraform on vsphere 8
  // https://github.com/hashicorp/terraform-provider-vsphere/issues/1902
  lifecycle {
    ignore_changes = [
      ept_rvi_mode,
      hv_mode,
    ]
  }
}

