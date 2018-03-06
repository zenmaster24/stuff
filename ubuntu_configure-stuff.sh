#!/bin/bash -ex
#sudo apt list --installed | grep $something
# remove stuff
sudo apt-get remove -y aisleriot gnome-color-manager firefox '^libreoffice*' gnome-mahjongg gnome-maps gnome-mines gnome-photos gnome-power-manager rhythmbox gnome-orca simple-scan gnome-sudoku

# need support for https repos
sudo apt install -y apt-transport-https

# add ms repo
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# add google repo
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

# add ubuntu-xboxdrv repo
sudo apt-add-repository -y ppa:rael-gc/ubuntu-xboxdrv

# add oracle repo
sudo add-apt-repository -y ppa:webupd8team/java

# add lutris repo
ver=$(lsb_release -sr); if [ $ver != "17.10" -a $ver != "17.04" -a $ver != "16.04" ]; then ver=16.04; fi
echo "deb http://download.opensuse.org/repositories/home:/strycore/xUbuntu_$ver/ ./" | sudo tee /etc/apt/sources.list.d/lutris.list
wget -q http://download.opensuse.org/repositories/home:/strycore/xUbuntu_$ver/Release.key -O- | sudo apt-key add -

# add playonlinuxrepo
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
sudo wget http://deb.playonlinux.com/playonlinux_precise.list -O /etc/apt/sources.list.d/playonlinux.list


# add pcsx2 repo
sudo add-apt-repository -y ppa:gregory-hainaut/pcsx2.official.ppa

# update repo list
sudo apt-get update

# install stuff
sudo apt install -y git steam code google-chrome-stable jstest-gtk oracle-java8-installer wine winbind lutris playonlinux virtualbox pcsx2 #ubuntu-xboxdrv

# get vagrant
wget -q https://releases.hashicorp.com/vagrant/2.0.2/vagrant_2.0.2_x86_64.deb -O ~/Downloads/vagrant_2.0.2_x86_64.deb
sudo dpkg -i ~/Downloads/vagrant_2.0.2_x86_64.deb

# get packer
wget -q https://releases.hashicorp.com/packer/1.2.0/packer_1.2.0_linux_amd64.zip -O ~/Downloads/packer_1.2.0_linux_amd64.zip
sudo unzip ~/Downloads/packer_1.2.0_linux_amd64.zip -d /usr/bin/

# get brettspeilwelt
wget -q http://www.brettspielwelt.de/Data/brettspielwelt.tar.gz -O ~/Downloads/brettspielwelt.tar.gz
cd ~/Downloads/
tar xzvf brettspielwelt.tar.gz
sudo mv BrettspielWelt /opt/BrettspielWelt

# get amd vulkan driver
wget -q https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-17.40-492261.tar.xz -O ~/Downloads/amdgpu-pro-17.40-492261.tar.xz

# install driver
cd ~/Downloads/
tar -Jxvf amdgpu-pro-17.40-492261.tar.xz
cd amdgpu-pro-17.40-492261.tar.xz
./amdgpu-pro-install -y

# manual steps.
# 1. sudo reboot
# 2. sudo usermod -a -G video $LOGNAME

# update everything
# sudo apt -y full-upgrade

# remove left overs
sudo apt -y auto-remove

# edit ~/.bashrc
touch ~/.vimrc
echo 'set nocompatible' >> ~/.vimrc
echo 'set backspace=2' >> ~/.vimrc

# create mount dir
mkdir -p /media/kirk/2tb

# add entry to fstabd
echo -e "UUID=b4defa2a-4ecd-4830-9411-82094d56f57c\t/media/kirk/2tb\text4\terrors=remount-ro\t0\t1" >> /etc/fstab

# symlink directories - target dir mus *NOT* exist
# ie for the below, ~/Downloads must not exist
# Downloads
rm -rf ~/Downloads/
ln -s /media/kirk/2tb/kirk/Downloads/

# comics
ln -s /media/kirk/2tb/kirk/comics/ ~/Documents/

# restart
shutdown -r now