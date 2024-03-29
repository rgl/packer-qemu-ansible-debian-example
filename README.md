# About

This shows how to provision a VM image using [Ansible](https://www.ansible.com/) from a [Packer](https://www.packer.io/) template.

# Usage (Ubuntu 22.04)

Install packer, qemu/kvm, docker, make, vagrant and the [Debian 12 vagrant box](https://github.com/rgl/debian-vagrant).

Provision the VM image and vagrant box:

```bash
make
```

Try using the VM image in a new VM:

```bash
vagrant box add -f packer-qemu-ansible-debian-example packer-qemu-ansible-debian-example.box
pushd example
vagrant up --no-destroy-on-error --no-tty --provider=libvirt
vagrant ssh
exit
vagrant destroy -f
popd
vagrant box remove -f packer-qemu-ansible-debian-example
```
