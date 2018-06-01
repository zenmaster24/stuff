#!/bin/bash
# stop on errors
set -ex

# install python3, pip and use pip to install virtual env
sudo apt install -y python3 python3-pip python3-apt && sudo pip3 install virtualenv

# set ansible environment name
ansible=${1:-ansible}

# set up a virtual env
virtualenv --system-site-packages "${ansible}"
# activate virtualenv
source "./${ansible}/bin/activate"
# install ansible
pip install ansible

# run ansible-pull
ansible-pull --clean --full --purge --url https://github.com/zenmaster24/ansible.git #--only-if-changed

# cleanup
deactivate