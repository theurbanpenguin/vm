packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
    vagrant = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

source "virtualbox-ovf" "existing-vm" {
  source_path = "/Users/andrewmallett/ova/r810.ova"
  communicator = "ssh"
  ssh_username = "vagrant"
  ssh_private_key_file = "~/.ssh/vagrant_insecure_private_key"
  shutdown_command = "sudo shutdown -P now"
}

build {
  name    = "rocky-8-10-server"
  sources = ["source.virtualbox-ovf.existing-vm"]

  provisioner "shell" {
    inline = [
      "echo 'Updating package list...'",
      "sudo yum update -y",
      "echo 'Updated system'",
    ]
  }

  post-processor "vagrant" {
    output = "output-vagrant-box/rocky810server.box"
  }
}