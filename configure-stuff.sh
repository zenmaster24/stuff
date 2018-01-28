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

# update repo list
sudo apt-get update

# install stuff
sudo apt install -y git steam code google-chrome-stable jstest-gtk oracle-java8-installer wine winbind lutris #ubuntu-xboxdrv

# get brettspeilwelt
wget -q http://www.brettspielwelt.de/Data/brettspielwelt.tar.gz -O ~/Downloads/brettspielwelt.tar.gz
cd ~/Downloads/
tar xzvf brettspielwelt.tar.gz
sudo mv BrettspielWelt /opt/BrettspielWelt

# update everything
sudo apt -y full-upgrade

# remove left overs
sudo apt -y auto-remove

# edit ~/.bashrc
touch ~/.vimrc
echo 'set nocompatible' >> ~/.vimrc
echo 'set backspace=2' >> ~/.vimrc

# restart
shutdown -r now
