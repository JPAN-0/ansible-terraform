
locals {
  linux_docker_runner_vm_count     = 13
  linux_docker_runner_vm_hostname  = "Docker-Runner"
  linux_docker_runner_vm_cpu_cores = 8
  linux_docker_runner_vm_mem       = 12288
  linux_docker_runner_vm_disk_size = 300
}

data "vsphere_virtual_machine" "docker_ubuntu_template" {
  name          = ""
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "ubuntu_docker_runner" {
  count = local.linux_docker_runner_vm_count

  name             = format("%s-%02d", local.linux_docker_runner_vm_hostname, count.index + 1)
  folder           = local.vcenter_devops_folders.prod_linux_runner
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = local.linux_docker_runner_vm_cpu_cores
  memory           = local.linux_docker_runner_vm_mem
  guest_id         = "ubuntu64Guest"
  firmware         = data.vsphere_virtual_machine.docker_ubuntu_template.firmware

  network_interface {
    network_id = data.vsphere_network.network.id

  }

  wait_for_guest_net_timeout = 5
  wait_for_guest_ip_timeout  = 5

  disk {
    label            = format("%s-%02d-disk", local.linux_docker_runner_vm_hostname, count.index + 1)
    thin_provisioned = data.vsphere_virtual_machine.docker_ubuntu_template.disks[0].thin_provisioned
    size             = local.linux_docker_runner_vm_disk_size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.docker_ubuntu_template.id
    customize {
      linux_options {
        host_name = format("%s-%02d", local.linux_docker_runner_vm_hostname, count.index + 1)
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
