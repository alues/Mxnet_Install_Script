#!bin/bash

cur_usr=`basename ~/`
cur_path=$(cd "$(dirname "$0")"; pwd)
DEV_MODE=true

# Stop the script when any Error occour
set -e

# Install System Status Monitor
sudo apt-get update
sudo apt-get install -y htop iotop

# Install Python Plugins
sudo apt-get install -y build-essential cmake git vim rar unrar unzip screen
sudo apt-get install -y python-dev python-pip python3-pip python-opencv

# Libs For numpy scipy scikit
sudo apt-get install -y libblas-dev libatlas-base-dev liblapack-dev libopencv-dev gfortran
# Libs For Pillow
sudo apt-get install -y libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk

pip_plugin_path=${cur_path}/Python_PKG

if [ -d ${pip_plugin_path} ]; then
    sudo pip install -U ${pip_plugin_path}/pip-*.tar.gz
    # Install PIP Plugins
    pip_plugin_list=(
        setuptools-*.zip
        numpy-*.zip
        graphviz-*.zip
        redis-*.tar.gz
        # Pillow
        olefile-*.zip
        Pillow-*.tar.gz
    )
    
    for v in ${pip_plugin_list[@]}; do
        sudo pip install ${pip_plugin_path}/${v}
    done
    
    sudo pip3 install -U ${pip_plugin_path}/pip-*.tar.gz
    # Install PIP3 Plugins
    pip3_plugin_list=(
        setuptools-*.zip
        numpy-*.zip
        PyYAML-*.tar.gz
        redis-*.tar.gz
        # Pillow
        olefile-*.zip
        Pillow-*.tar.gz
        # LMDB
        lmdb-*.tar.gz
    )

    for v in ${pip3_plugin_list[@]}; do
        sudo pip3 install ${pip_plugin_path}/${v}
    done
fi


# Extract Pycharm
pycharm_path=${cur_path}/Pycharm

if [ ${DEV_MODE} = true ] && [ -d ${pycharm_path} ]; then
    tar -xvf ${pycharm_path}/pycharm-*.tar.gz -C ~/
    sudo chown -R ${cur_usr} ~/pycharm-*
fi  

# Init Mxnet -> Env
PROFILE_ROOT=/etc/profile.d/digits.sh

echo 'export MXNET_ROOT=~/mxnet' >> ${PROFILE_ROOT}
echo 'export PYTHONPATH=$MXNET_ROOT/python:$PYTHONPATH' >> ${PROFILE_ROOT}
echo "export DEV_MODE=${DEV_MODE}" >> ${PROFILE_ROOT}

source ${PROFILE_ROOT}

# Init SSH Server
ssh_root=${cur_path}/SSH

if [ -d ${ssh_root} ]; then
    sudo bash ${ssh_root}/Install_SSH.sh
fi
