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
  source_path      = "/Users/andrewmallett/Virtual Machines.localized/Rocky_Linux_810.vmwarevm/Rocky_Linux_810.vmx"
  communicator     = "ssh"
  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  shutdown_command = "sudo poweroff"
}

build {
  sources = ["source.vmware-vmx.vmware"]

  #provisioner "shell" {
   # script = "setup.sh"
  #}

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "rocky_810_vmware.box"
  }
}
