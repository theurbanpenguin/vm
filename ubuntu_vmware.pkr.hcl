packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vmware"
    }
    vagrant = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vagrant"
    }
  }
}

source "vmware-vmx" "vmware" {
  source_path      = "/Users/andrewmallett/Virtual Machines.localized/noble_arm.vmwarevm/noble_arm.vmx"
  communicator     = "ssh"
  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  shutdown_command = "sudo poweroff"
}

build {
  sources = ["source.vmware-vmx.vmware"]
  provisioner "shell" {
   inline = [
        "sudo apt-get update",
        "sudo apt-get upgrade -y ",
        "sudo apt-get clean",
        "sudo apt-get autoremove -y",
        "history -c",
        "history -w"
      ]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "vmware_arm.box"
  }
}
