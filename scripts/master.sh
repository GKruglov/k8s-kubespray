#!/usr/bin/env bash

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> GENERATE SSH KEY PAIR"
sudo mkdir ~/.ssh/
cd ~/.ssh/
ssh-keygen -f id_rsa -t rsa -N ''
eval $(ssh-agent -s) && ssh-add ~/.ssh/id_rsa
sudo cp ~/.ssh/id_rsa.pub /vagrant/control.pub
sudo cat ~/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
sudo chmod 700 ~/.ssh && chmod 600 ~/.ssh/*
#sudo restorecon -R -v ~/.ssh
echo "SSH key pair generation finished!"

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SETUP LIBS AND TOOLS"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https unzip vim tmux software-properties-common curl wget rsync git python-pip ansible

#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SETUP KUBECTL"
#curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
#echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
#sudo apt-get update
#sudo apt-get install -y kubectl

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SETUP KUBESPRAY"
cd ~
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray

pip install ruamel_yaml  --user
pip install -r requirements.txt --user

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PREPARE KUBESPRAY ENV"
mkdir inventory/mycluster
cp -rfp inventory/sample/* inventory/mycluster
cp /vagrant/inventory.ini inventory/mycluster/

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> PUSH PS1"
echo 'PS1="\[\e[00;33m\][\[\e[0m\]\[\e[00;35m\]\t\[\e[0m\]\[\e[00;33m\]]\[\e[0m\]\[\e[00;37m\] \[\e[0m\]\[\e[00;36m\]\u\[\e[0m\]\[\e[00;31m\]@\[\e[0m\]\[\e[00;32m\]\H\[\e[0m\]\[\e[00;37m\]\n\[\e[0m\]\[\e[01;36m\]\\$\[\e[0m\]\[\e[01;34m\]:\[\e[0m\]\[\e[00;33m\]\w\[\e[0m\]\[\e[01;34m\]:\[\e[0m\]\[\e[01;31m\]\$?\[\e[0m\]\[\e[00;31m\]>\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"' >> ~/.bashrc
echo "cd /vagrant/" >> ~/.bashrc
echo "alias tmux='TERM=screen-256color-bce tmux'" >> ~/.bashrc
cat <<EOF | tee ~/.ssh/config
Host *
    ForwardAgent    yes
    VisualHostKey   yes
	StrictHostKeyChecking no
EOF
cat <<EOF | tee ~/.ssh/rc
#!/bin/bash
if [ -S "$SSH_AUTH_SOCK" ]; then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi
EOF
sudo chmod +x ~/.ssh/rc
cat <<EOF | tee ~/.tmux.conf
set-window-option -g xterm-keys on
set -g default-terminal "screen-256color"
set -g update-environment -r
set -g history-limit 100000
set-option -g status-bg colour235 #base02
set-option -g status-fg colour136 #yellow
set-option -g status-attr default
set-window-option -g window-status-fg colour244 #base0
set-window-option -g window-status-bg default
set-window-option -g window-status-current-fg colour166 #orange
set-window-option -g window-status-current-bg default
set -g update-environment "DISPLAY SSH_ASKPASS SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY"
set-environment -g 'SSH_AUTH_SOCK' ~/.ssh/ssh_auth_sock
EOF
