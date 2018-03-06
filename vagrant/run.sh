#!/bin/sh -e

echo -e "Running Packer on $(date)\n------------------------------------------------------------"
# Prepend to packer command for vebose logs on stdout
# PACKER_LOG=1

packer build .Packerfile

echo -e "Finished running Packer on $(date)\n------------------------------------------------------------"

# echo -e "Running Vagrant on $(date)\n------------------------------------------------------------"
# vagrant box add windows10 ./windows_10_virtualbox.box

# echo -e "Setting up Virtualbox VM on $(date)\n------------------------------------------------------------"
# mkdir ~/VirtualBox\ VMs\\Windows10
# cd ~/VirtualBox\ VMs\\Windows10
# vagrant init windows10
# vagrant up