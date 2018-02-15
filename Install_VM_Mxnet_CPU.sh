#!bin/bash

cur_usr=`basename ~/`
cur_path=$(cd "$(dirname "$0")"; pwd)
cur_sys=`cat /etc/*-release | sed -r "s/^ID=(.*)$/\\1/;tA;d;:A;s/^\"(.*)\"$/\\1/"`
cur_workdir=${cur_path}/Mxnet

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

Mxnet_Kit_list=(
    # Mxnet
    mxnet*.tar.gz 
)

# Dectect Mxnet & Warp-CTC
for v in ${Mxnet_Kit_list[@]}; do
    if [ ! -f ${cur_workdir}/${v} ]; then
        echo_error 'Please make sure u had download Mxnet & Warp-CTC'
        echo_success "Problem could be solved by reading ${cur_workdir}/readme.md"
        echo_error "${cur_workdir}/${v} Needed"
        exit 1
    fi
done

sudo apt-get update
sudo apt-get install -y build-essential git
sudo apt-get install -y libopenblas-dev liblapack-dev libopencv-dev libatlas-base-dev
sudo apt-get install -y python-dev python-setuptools python-numpy python-pip python3-pip python-opencv

pip_plugin_path=${cur_path}/Python_PKG

if [ -d ${pip_plugin_path} ]; then
    sudo pip install --no-cache-dir -U ${pip_plugin_path}/pip-*.tar.gz
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
        sudo pip install --no-cache-dir ${pip_plugin_path}/${v}
    done
    
    sudo pip3 install --no-cache-dir -U ${pip_plugin_path}/pip-*.tar.gz
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
        sudo pip3 install --no-cache-dir ${pip_plugin_path}/${v}
    done
fi

tar -zxvf ${cur_workdir}/mxnet*.tar.gz -C ~/
cd ~/mxnet
sudo make -j $(nproc) USE_OPENCV=1 USE_BLAS=openblas

cd ~/mxnet/python
sudo pip install --no-cache-dir -e .

echo_success "Mxnet Install Done"
