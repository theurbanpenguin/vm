#!/bin/bash

# Create SSH directory and set permissions
mkdir -m 700 /home/vagrant/.ssh
curl -L https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub > /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Allow passwordless sudo for vagrant user
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/vagrant
sudo chmod 0440 /etc/sudoers.d/vagrant

# uncomment the bell to ensure no bell on tab completion
sudo sed -i '/#set bell-style none/s/^#//' /etc/inputrc

# Update and install necessary packages
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl \
                    wget \
                    git \
                    vim \
                    nano \
                    tree \
                    bash-completion \
                    python3 \
                    python3-pip

virtualization=$(hostnamectl | awk '/Virtualization:/ {print $2}')

# Check if the virtualization is VirtualBox (Oracle) or VMWare
if [ "$virtualization" = "oracle" ]; then
    echo "Virtualization is Oracle"
    sudo apt install -y dkms build-essential linux-headers-generic
    echo "Please insert Guest Additions CD 'c' to continue..."
    read input

    # Loop until the user enters 'c'
    while [[ "$input" != "c" ]]; do
        echo "Incorrect input. Please enter 'c' to continue..."
        read input
    done
    sudo mount /dev/cdrom /mnt
    sudo /mnt/VBoxLinuxAdditions.run
    sudo umount /mnt
elif [ "$virtualization" = "vmware" ]; then
    echo "Virtualization is VMWare"
    sudo apt install -y open-vm-tools
    sudo systemctl enable --now vmtoolsd
fi

# Set up time synchronization
sudo timedatectl set-timezone UTC
sudo timedatectl set-ntp true

sudo apt autoremove -y
sudo apt clean

# Clear logs
sudo find /var/log -type f -exec truncate -s 0 {} \;

# Zero out the free space to save space in the final image
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY

# Clear bash history
history -c
history -w