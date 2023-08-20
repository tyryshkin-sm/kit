variable "iso_url" {
  type = string
  default = "https://releases.ubuntu.com/22.04.2/ubuntu-22.04.2-live-server-amd64.iso"
}

variable "iso_checksum" {
  type = string
  default = "sha256:5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
}

variable "tmp_directory" {
  type = string
  default = "/tmp"
}

variable "in_directory" {
  type = string
  default = "/in"
}

variable "out_directory" {
  type = string
  default = "/out"
}

variable "out_image" {
  type = string
  default = "ubuntu"
}

variable "out_tag" {
  type = string
  default = "2004"
}

variable "display" {
  type = bool
  default = true
}

source "qemu" "build" {
  iso_url           = "${var.iso_url}"
  iso_checksum      = "${var.iso_checksum}"
  output_directory  = "${var.out_directory}"

  accelerator         = "kvm"
  use_default_display = !var.display
  vm_name             = "${var.out_image}-${var.out_tag}"
  memory              = 2048
  format              = "qcow2"
  disk_size           = "10G"
  disk_interface      = "virtio"
  net_device          = "virtio-net"

  ssh_username        = "user"
  ssh_password        = "123456"
  ssh_timeout         = "30m"

  http_directory      = "${var.in_directory}/autoinstall"
  boot_wait           = "10s"
  boot_command        = [
    "<esc><esc><esc><esc>e<wait>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del><del><del><del><del><del><del><del>",
    "<del>",
    "linux /casper/vmlinuz autoinstall ds='nocloud-net;s=http://{{.HTTPIP}}:{{.HTTPPort}}/'<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "<f10>",
  ]
  shutdown_command = "sudo poweroff"
  shutdown_timeout = "5m"
}

build {
  sources = ["source.qemu.build"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3-pip",
      "sudo pip3 install pytest"
    ]
  }

  provisioner "shell" {
    inline = [
      "mkdir -p ${var.tmp_directory}"
    ]
  }

  provisioner "file" {
    source      = "${var.in_directory}/pytest"
    destination = "${var.tmp_directory}/pytest"
  }

  provisioner "ansible" {
    user          = "user"
    playbook_file = "${var.in_directory}/ansible/playbook.yaml"
  }

  provisioner "shell" {
    inline = [
      "pytest ${var.tmp_directory}/pytest"
    ]
  }

  post-processor "manifest" {
    output              = "${var.out_directory}/manifest.json"
    keep_input_artifact = true
    strip_path          = true
  }
}
