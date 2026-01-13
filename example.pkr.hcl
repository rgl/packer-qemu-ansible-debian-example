packer {
  required_plugins {
    # see https://github.com/hashicorp/packer-plugin-vagrant
    vagrant = {
      version = "1.1.6"
      source  = "github.com/hashicorp/vagrant"
    }
    # see https://github.com/hashicorp/packer-plugin-ansible
    ansible = {
      version = "1.1.4"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "disk_size" {
  type    = string
  default = "61440"
}

variable "disk_image" {
  type = string
}

variable "vagrant_box" {
  type = string
}

source "qemu" "example" {
  headless          = true
  accelerator       = "kvm"
  machine_type      = "q35"
  efi_boot          = true
  efi_firmware_code = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  efi_firmware_vars = "/usr/share/OVMF/OVMF_VARS_4M.fd"
  cores             = 2
  memory            = 2 * 1024
  qemuargs = [
    ["-cpu", "host"],
  ]
  disk_size        = var.disk_size
  disk_interface   = "virtio-scsi"
  disk_cache       = "unsafe"
  disk_discard     = "unmap"
  disk_image       = true
  use_backing_file = true
  net_device       = "virtio-net"
  iso_url          = var.disk_image
  iso_checksum     = "none"
  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  ssh_timeout      = "60m"
  boot_wait        = "5s"
  shutdown_command = "sudo poweroff"
}

build {
  sources = [
    "source.qemu.example",
  ]
  provisioner "ansible" {
    command       = "./ansible-playbook.sh"
    playbook_file = "playbook.yml"
  }
  # TODO https://github.com/hashicorp/packer-plugin-vagrant/issues/44
  post-processor "vagrant" {
    output               = var.vagrant_box
    vagrantfile_template = "Vagrantfile.template"
  }
}