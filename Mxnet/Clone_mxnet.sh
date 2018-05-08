#!/usr/bin/env -S -P /usr/local/bin:/usr/bin:${PATH} bash

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

function git_clone_compress(){
    git clone --recursive ${1} ${cur_path}/${2}
    tar -zcvf ${cur_path}/${2}.tar.gz -C ${cur_path}/${2} $(ls -A ${cur_path}/${2})
    rm -rf ${cur_path}/${2}
}

git_clone_compress https://github.com/apache/incubator-mxnet.git mxnet
git_clone_compress https://github.com/baidu-research/warp-ctc.git warp-ctc

echo_success "Clone Done!"
