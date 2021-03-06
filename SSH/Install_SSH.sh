#!/usr/bin/env -S -P /usr/local/bin:/usr/bin:${PATH} bash

cur_usr=${1:-${SUDO_USER:-$(whoami)}}
cur_home=`cat /etc/passwd | grep ${cur_usr} | awk -F ":" '{print $6}'`
cur_path=$(cd "$(dirname "$0")"; pwd)
cur_workdir=${cur_path}/SSH-KEY
cur_sys=`cat /etc/*-release | sed -r "s/^ID=(.*)$/\\1/;tA;d;:A;s/^\"(.*)\"$/\\1/" | tr -d '\n'`

# Stop the script when any Error occur
set -e

# Functions
Color_Error='\E[1;31m'
Color_Success='\E[1;32m'
Color_Res='\E[0m'

function echo_error(){
    echo -e "${Color_Error}${1}${Color_Res}"
}

function echo_success(){
    echo -e "${Color_Success}${1}${Color_Res}"
}

function docker_detect(){
    if [ -f /.dockerenv* ]; then
        printf true
    else
        printf false
    fi
}

# Update the apt List
case ${cur_sys} in
    "ubuntu")
        sudo apt-get update
        sudo apt-get install -y openssh-server
    ;;
    "centos")
        sudo yum install -y openssh-server
    ;;
esac

# Create sshd dir
sudo mkdir -p ${cur_home}/.ssh

# Auth Pub KEY
if [ -f ${cur_workdir}/id_*.pub ]; then
    cat ${cur_workdir}/id_*.pub > ${cur_home}/.ssh/authorized_keys
    chmod 644 ${cur_home}/.ssh/authorized_keys
fi

# Switch Permission
sudo chmod 700 ${cur_home}/.ssh
chown -R ${cur_usr} ${cur_home}/.ssh

# Disable Password Login
sudo sed -ri "s/^\s*#?(\s*PasswordAuthentication)\s+(yes|no)\$/\\1 no/g" /etc/ssh/sshd_config
sudo sed -ri "s/^\s*#?(\s*UsePAM)\s+(yes|no)\$/\\1 no/g" /etc/ssh/sshd_config
sudo sed -ri "s/^\s*#?(\s*HostKey\s+.*)\$/#\\1/g" /etc/ssh/sshd_config

case ${cur_sys} in
    "ubuntu")
        if `docker_detect`; then
            sudo service ssh restart
        else
            sudo systemctl restart ssh.service
        fi
    ;;
    "centos")
        if `docker_detect`; then
            sudo service sshd restart
        else
            sudo systemctl restart sshd.service
        fi
    ;;
esac

echo_success "SSH Server Ready"
