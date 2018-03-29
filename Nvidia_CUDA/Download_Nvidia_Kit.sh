#!/usr/bin/env bash

cur_path=$(cd "$(dirname "$0")"; pwd)

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

echo_error "Download : Nvidia-Driver"
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/390.25/NVIDIA-Linux-x86_64-390.25.run -P ${cur_path}/
echo_success "Download : Nvidia-Driver -> [ Done ]"

echo_error "Download : CUDA-Kit"
wget https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux -O cuda_9.1.85_387.26_linux.run -P ${cur_path}/
echo_success "Download : CUDA-Kit -> [ Done ]"

echo_error "Download : CUDNN-Kit"

echo_success "Download : CUDNN-Kit -> [ Done ]"

echo_success "Download Done!"
