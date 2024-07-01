# GitLab Runner Ansible

## Ansible Vaults

This repository is using variable files encrypted with the ansible-vault feature.

<https://www.digitalocean.com/community/tutorials/how-to-use-vault-to-protect-sensitive-ansible-data>

All the examples here assume that a file called *.vault_pass* exists in this directory, and use the `vault_password_file` configuration option to give the path to ansible.
The password is the standard main password used for internal systems.

For the gitlab linux runners, the sudo password is also stored in a vault, so it's only necessary to provide the vault password and then everything "should just work".

### Vault Files

Currently there are vaults for the following groups :-
  * gitlab_linux_runners
      holds the standard become pass as well as minio credentials
  * minio
      holds the standard become pass
  * prometheus
      holds the standard become pass and the vcenter creds to setup the vmware exporter

The vsphere inventory file is also vaulted because that has the vCenter credentials in.

## SSH Keys

The inventory is configured to look for the correct SSH key file at the path *sshkeys/gitlab_runner_key*.

## Python Environment

To run this it's worth setting up a python virtual-env so that you don't have to install the packages and libraries in your global python environment. All the python dependencies can be installed by `pip`.

The main library dependencies are
* ansible
* jmespath
* tomli
* tomli_w
* vsphere-automation-sdk
      installed from git+https://github.com/vmware/vsphere-automation-sdk-python.git

You'll also need to install some ansible roles from the ansible galaxy package manager. This can be done with the `ansible-galaxy` tool.

```
pip install -r requirements.txt
ansible-galaxy install -r requirements.yml
echo <ansible_vault_password> > .vault_pass
```

## Basic Useful Things

* Ping all the available hosts in the inventory.
  `ansible all -m ping`
  This will probably include some failures for hosts that are retrieved from VSphere but don't use the gitlab runner SSH key
* Graph all the hosts in the inventory and their variables.
  `ansible-inventory --graph`
* Get information about all hosts
  `ansible-playbook info.yml`
* Get information about a single host
  `ansible-playbook --limit hdkrunner-02 info.yml`


### Remote desktop access

Needs to be enabled in system settings

### SSH Keys

The easiest way to do add the SSH keys is with `ssh-copy-id`. 

### XCode or Command Line Tools

The full XCode install needs to be done via the app store.

If the full XCode install isn't needed, then the command line tools need to be installed. On the mac, open up a terminal and run `xcode-select --install`. This should show a pop-up that asks if you want to install the command-line tools. Hit ok and then wait for them to be installed.

