#! /bin/bash -fv
HOME=/home/stack
mkdir ${HOME}/images
mkdir ${HOME}/templates
sudo hostnamectl set-hostname ${1}.aardvark.lab
sudo hostnamectl set-hostname --transient ${1}.aardvark.lab
sudo sed "1s/localhost/${1}.aardvark.lab ${1} localhost/" /etc/hosts > /tmp/hosts
sudo cp /tmp/hosts /etc/hosts
