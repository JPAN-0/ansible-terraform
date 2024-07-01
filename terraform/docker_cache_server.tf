
locals {
  docker_cache_server_vm_count     = 1
  docker_cache_server_vm_hostname  = "Docker-Cache-Server"
  docker_cache_server_vm_cpu_cores = 8
  docker_cache_server_vm_mem       = 12288
  docker_cache_server_vm_disk_size = 300
}

data "vsphere_virtual_machine" "docker_cache_server" {
  name          = ""
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "docker_cache_server" {
  count = local.docker_cache_server_vm_count

  name             = format("%s-%02d", local.docker_cache_server_vm_hostname, count.index + 1)
  folder           = local.vcenter_devops_folders.docker
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = local.docker_cache_server_vm_cpu_cores
  memory           = local.docker_cache_server_vm_mem
  guest_id         = "ubuntu64Guest"
  firmware         = data.vsphere_virtual_machine.docker_cache_server.firmware

  network_interface {
    network_id = data.vsphere_network.network.id

  }

  wait_for_guest_net_timeout = 5
  wait_for_guest_ip_timeout  = 5

  disk {
    label            = format("%s-%02d-disk", local.docker_cache_server_vm_hostname, count.index + 1)
    thin_provisioned = data.vsphere_virtual_machine.docker_cache_server.disks[0].thin_provisioned
    size             = local.docker_cache_server_vm_disk_size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.docker_cache_server.id
    customize {
      linux_options {
        host_name = format("%s-%02d", local.docker_cache_server_vm_hostname, count.index + 1)
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
