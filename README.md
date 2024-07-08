# GitLab vCenter Runners

There are four main sections to this repo.

The *terraform* folder contains everything needed to spin up instances on vCenter. Instances can be any type of OS; The template source path just needs to be changed.

The *ansible* folder contains all the provisioning playbooks for the runners, as well as any roles we've created. The inventory is integrated with vCenter so ansible can discover the IP addresses based on the host name.

The *packer* folder is for machine image build configuration.

The *test* folder is for small projects that are used in CI runner tests.

## Current Runner State

* :white_check_mark: Linux docker runners
    * Fully automated with terraform and ansible
* :heavy_check_mark: Windows docker runners
    * Fully automated with terraform and ansible
* :heavy_check_mark: Windows docker builders
    * Fully automated with terraform and ansible

## Support Servers

* :heavy_check_mark: MinIO
    * Creation and setup fully automated
* :heavy_check_mark: Prometheus
    * Creation and setup fully automated, but needs bit of effort to make it fully resilient
* :heavy_check_mark: Grafana
    * Creation and setup fully automated
* :heavy_check_mark: Docker Cache Registry
    * Creation and setup fully automated
