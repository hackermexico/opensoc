#!/bin/bash

# Function to install a package via apt (Debian/Ubuntu)
install_package() {
    sudo apt update
    sudo apt install -y "$1"
}

# Install osquery
install_osquery() {
    install_package osquery
}

# Install Webmin
install_webmin() {
    sudo sh -c 'echo "deb https://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list' &&
    wget -q -O- http://www.webmin.com/jcameron-key.asc | sudo apt-key add - &&
    sudo apt update &&
    sudo apt install -y webmin
}

# Install OpenSSH server
install_ssh_server() {
    install_package openssh-server
}

# Install OpenVPN server
install_openvpn_server() {
    install_package openvpn
}

# Install OSSEC/Wazuh
install_ossec_wazuh() {
    curl -so /tmp/wazuh-agent.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.2.4-1_amd64.deb &&
    sudo dpkg -i /tmp/wazuh-agent.deb
}

# Install Rancher
install_rancher() {
    sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
}

# Install Docker
install_docker() {
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh &&
    sudo sh /tmp/get-docker.sh
}

# Install Nmap
install_nmap() {
    install_package nmap
}

# Install OpenVAS
install_openvas() {
    install_package openvas
}

# Install Snort
install_snort() {
    install_package snort
}

# Config
