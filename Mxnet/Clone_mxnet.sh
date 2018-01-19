#!bin/bash

# Stop the script when any Error occur
set e

git clone --recursive https://github.com/apache/incubator-mxnet.git ./mxnet 
tar -zcvf mxnet.tar.gz ./mxnet

git clone --recursive https://github.com/baidu-research/warp-ctc.git ./warp-ctc 
tar -zcvf warp-ctc.tar.gz ./warp-ctc
