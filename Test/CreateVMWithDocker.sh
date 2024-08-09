#!/bin/bash

# Workdit for Vagrant
WORKDIR="./vagrant-debian11"
mkdir -p "$WORKDIR"
cd "$WORKDIR" || exit

# Creating VM with Vagrant
if [ ! -f "Vagrantfile" ]; then
    vagrant init debian/bullseye64

    cat <<EOF > Vagrantfile
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
#Bypassing Vagrant Cloud blocking in Russia
ENV['VAGRANT_SERVER_URL'] = 'https://vagrant.elab.pro'

Vagrant.configure("2") do |config|
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "AnsibleTest.yml"
  end
  config.vm.define "Debian11_VM" do |vm_conf|
    vm_conf.vm.box = "debian/bullseye64"
    vm_conf.vm.provider "virtualbox" do |vb|
      vb.name = "VagrantVM"
      vb.gui = false
      vb.memory = 1024
      vb.cpus = 1
    end
  end
end
EOF
    echo "Vagrantfile initialized"
else
    echo "Vagrantfile already exists. Skipping..."
fi

# Creating Ansible playbook for Docker installation
ANSIBLE_PLAYBOOK="AnsibleTest.yml"
if [ ! -f "$ANSIBLE_PLAYBOOK" ]; then
    cat <<EOF > $ANSIBLE_PLAYBOOK
---
- hosts: all
  become: true
  vars:
    default_container_name: docker
    default_container_image: ubuntu
    default_container_command: sleep 1

  tasks:
    - name: Install required system packages
      apt:
        pkg:
          - apt-transport-https
          - ca-certificates
          - curl
          - software-properties-common
          - virtualenv
        state: latest
        update_cache: true

    - name: Add Docker GPG apt Key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    - name: Add Docker Repository
      apt_repository:
        repo: deb https://download.docker.com/linux/ubuntu focal stable
        state: present

    - name: Update apt and install docker-ce
      apt:
        name: docker-ce
        state: latest
        update_cache: true

    - name: Pull default Docker image
      community.docker.docker_image:
        name: "{{ default_container_image }}"
        source: pull

    - name: Create default containers
      community.docker.docker_container:
        name: "{{ default_container_name }}_for_Infotecs_Internship"
        image: "{{ default_container_image }}"
        command: "{{ default_container_command }}"
        state: present
EOF
    echo "Ansible playbook initialized"
else
    echo "Ansible playbook already exists. Skipping..."
fi

vagrant up

# Choosing whether user wants to connect to VM
read -p "Hey, infotecs user, do you want to connect to VM? (y/n):" answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
 echo "Of course you are! Connecting..."
 vagrant ssh
fi
