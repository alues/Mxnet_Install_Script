#!/usr/bin/env -S -P /usr/local/bin:/usr/bin:${PATH} bash

cur_usr=${SUDO_USER:-$(whoami)}
cur_path=$(cd "$(dirname "$0")"; pwd)
cur_sys=`cat /etc/*-release | sed -r "s/^ID=(.*)$/\\1/;tA;d;:A;s/^\"(.*)\"$/\\1/" | tr -d '\n'`
cur_workdir=${cur_path}/Mxnet
# Defined in ENV script
MXNET_INSTALL_ROOT=/usr/local/mxnet

# Stop the script when any Error occur
set -e

PROFILE_ROOT=/etc/profile.d/digits.sh
if [ -e ${PROFILE_ROOT} ]; then
    source ${PROFILE_ROOT}
fi

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
    # Warp-CTC
    warp-ctc*.tar.gz
)

# Dectect Mxnet & Warp-CTC
for v in ${Mxnet_Kit_list[@]}; do
    if [ -e ${cur_workdir}/${v} ]; then
        echo_success "Found -> [ $(basename ${cur_workdir}/${v}) ]"
    else
        if [ -e ${cur_workdir}/Clone_mxnet.sh ]; then
            echo_error 'Try to Download Mxnet & Warp-CTC'
            sudo bash ${cur_workdir}/Clone_mxnet.sh
        else
            echo_error 'Please make sure u had download Mxnet & Warp-CTC'
            echo_success "Problem could be solved by reading ${cur_workdir}/Readme.md"
            echo_error "${cur_workdir}/${v} Needed"
            exit 1
        fi
    fi
done


# Extarct Mxnet
mkdir ${MXNET_INSTALL_ROOT}
sudo tar -zxvf ${cur_workdir}/mxnet*.tar.gz -C ${MXNET_INSTALL_ROOT}
# Extarct CTC
mkdir ${MXNET_INSTALL_ROOT}/warp-ctc
sudo tar -zxvf ${cur_workdir}/warp-ctc*.tar.gz -C ${MXNET_INSTALL_ROOT}/warp-ctc

sudo chown -R ${cur_usr} ${MXNET_INSTALL_ROOT}
# Install Warp-CTC
cd ${MXNET_INSTALL_ROOT}/warp-ctc
mkdir -p build
cd build
cmake ..
make -j$(nproc)
sudo make install
sudo ldconfig

# Install Mxnet
cd ${MXNET_INSTALL_ROOT}
cp make/config.mk .

echo 'USE_CUDA = 1' >>config.mk
echo 'USE_CUDA_PATH = /usr/local/cuda' >>config.mk
echo 'USE_CUDNN = 1' >>config.mk
echo 'WARPCTC_PATH = $(HOME)/warp-ctc' >>config.mk
echo 'MXNET_PLUGINS += plugin/warpctc/warpctc.mk' >>config.mk

make clean
make -j$(nproc)

# Install Python Plugins
sudo apt-get install -y ipython ipython-notebook

# Install Mxnet Python
cd ${MXNET_INSTALL_ROOT}/python
sudo pip2 install --no-cache-dir -e .
sudo pip3 install --no-cache-dir -e .

# Install Python PIP Plugins
sudo -H pip2 install graphviz
sudo -H pip3 install graphviz
# sudo pip install jupyter

echo_success "Done! MXNet for Python installation is complete. Go ahead and explore MXNet with Python :-)"
