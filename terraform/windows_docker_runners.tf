locals {
  windows_docker_runner_vm_count         = 5
  windows_docker_runner_vm_vcenter_name  = "Windows-Docker-Runner"
  windows_docker_runner_vm_hostname      = "D-W22-S"
  windows_docker_runner_vm_cpu_cores     = 6
  windows_docker_runner_vm_mem           = 16384
  windows_docker_runner_vm_disk_size     = 90
}

data "vsphere_virtual_machine" "windows_docker_template" {
  name          = "Docker-Windows2022-Template"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "windows_docker_runner" {
  count = local.windows_docker_runner_vm_count

  name             = format("%s-%02d", local.windows_docker_runner_vm_vcenter_name, count.index + 1)
  folder           = local.vcenter_devops_folders.windows_docker
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = local.windows_docker_runner_vm_cpu_cores
  memory           = local.windows_docker_runner_vm_mem
  guest_id         = "windows2019srvNext_64Guest"
  firmware         = data.vsphere_virtual_machine.windows_docker_template.firmware

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  wait_for_guest_net_timeout = 5
  wait_for_guest_ip_timeout  = 5

  disk {
    label            = format("%s-%02d-disk", local.windows_docker_runner_vm_hostname, count.index + 1)
    thin_provisioned = data.vsphere_virtual_machine.windows_docker_template.disks[0].thin_provisioned
    size             = local.windows_docker_runner_vm_disk_size
  }

  extra_config = {
    "isolation.tools.copy.disable"         = "FALSE"
    "isolation.tools.paste.disable"        = "FALSE"
    "isolation.tools.setGUIOptions.enable" = "TRUE"
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.windows_docker_template.id
    timeout       = 15
    customize {
      windows_options {
        computer_name = format("%s-%02d", local.windows_docker_runner_vm_hostname, count.index + 1)
        workgroup     = ""
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
