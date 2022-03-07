packer {
  required_plugins {
    # see https://github.com/hashicorp/packer-plugin-vagrant
    vagrant = {
      version = "1.0.1"
      source = "github.com/hashicorp/vagrant"
    }
    # see https://github.com/hashicorp/packer-plugin-ansible
    ansible = {
      version = "1.0.1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "disk_size" {
  type = string
  default = "61440"
}

variable "disk_image" {
  type = string
}

variable "vagrant_box" {
  type = string
}

source "qemu" "example" {
  accelerator = "kvm"
  qemuargs = [
    ["-m", "2048"],
    ["-smp", "2"],
  ]
  headless = true
  disk_size = var.disk_size
  disk_interface = "virtio-scsi"
  disk_discard = "unmap"
  disk_image = true
  use_backing_file = true
  iso_url = var.disk_image
  iso_checksum = "none"
  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_timeout = "60m"
  boot_wait = "5s"
  shutdown_command = "sudo poweroff"
}

build {
  sources = [
    "source.qemu.example",
  ]
  provisioner "ansible" {
    command = "./ansible-playbook.sh"
    playbook_file = "playbook.yml"
  }
  # TODO https://github.com/hashicorp/packer-plugin-vagrant/issues/44
  post-processor "vagrant" {
    output = var.vagrant_box
    vagrantfile_template = "Vagrantfile.template"
  }
}