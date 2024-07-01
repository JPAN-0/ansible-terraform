
data "vsphere_virtual_machine" "prometheus_ubuntu_template" {
  name          = "linux-ubuntu-22.04-lts-0.0.3"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

locals {
  prometheus_vm_hostname  = "prometheus-01"
  prometheus_vm_cpus      = "4"
  prometheus_vm_memory    = "12288"
  prometheus_vm_disk_size = "100"
}

resource "vsphere_virtual_machine" "prometheus" {

  name             = local.prometheus_vm_hostname
  folder           = local.vcenter_devops_folders.core
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = local.prometheus_vm_cpus
  memory           = local.prometheus_vm_memory
  guest_id         = "ubuntu64Guest"
  firmware         = data.vsphere_virtual_machine.prometheus_ubuntu_template.firmware

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  wait_for_guest_net_timeout = 5
  wait_for_guest_ip_timeout  = 5

  disk {
    label            = "${local.prometheus_vm_hostname}-disk"
    thin_provisioned = data.vsphere_virtual_machine.prometheus_ubuntu_template.disks[0].thin_provisioned
    size             = local.prometheus_vm_disk_size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.prometheus_ubuntu_template.id
    customize {
      linux_options {
        host_name = local.prometheus_vm_hostname
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

data "vsphere_virtual_machine" "grafana_ubuntu_template" {
  name          = "linux-ubuntu-22.04-lts-0.0.3"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

locals {
  grafana_vm_hostname  = "grafana-01"
  grafana_vm_cpus      = "1"
  grafana_vm_memory    = "4096"
  grafana_vm_disk_size = "40"
}

resource "vsphere_virtual_machine" "ci_grafana" {

  name             = local.grafana_vm_hostname
  folder           = local.vcenter_devops_folders.core
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = local.grafana_vm_cpus
  memory           = local.grafana_vm_memory
  guest_id         = "ubuntu64Guest"
  firmware         = data.vsphere_virtual_machine.grafana_ubuntu_template.firmware

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  wait_for_guest_net_timeout = 5
  wait_for_guest_ip_timeout  = 5

  disk {
    label            = "${local.grafana_vm_hostname}-disk"
    thin_provisioned = data.vsphere_virtual_machine.grafana_ubuntu_template.disks[0].thin_provisioned
    size             = local.grafana_vm_disk_size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.grafana_ubuntu_template.id
    customize {
      linux_options {
        host_name = local.grafana_vm_hostname
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

