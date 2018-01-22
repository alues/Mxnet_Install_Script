#!bin/bash

cur_path=$(cd "$(dirname "$0")"; pwd)
cur_workdir=${cur_path}/Nvidia_CUDA

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

CUDA_Kit_list=(
    # CUDA
    cuda_*_*_linux.run
    # CUDNN
    cudnn-*.tgz
)

# Dectect CUDA & CUDNN 
for v in ${CUDA_Kit_list[@]}; do
    if [ ! -f ${cur_workdir}/${v} ]; then
        echo_error 'Please make sure u had download CUDA & CUDNN Kit'
        echo_success "Problem by reading ${cur_workdir}/readme.md"
        echo_error "${cur_workdir}/${v} Needed"
        exit 1
    fi
done

# Disable the Nouveau
sudo service lightdm stop
Nouveau_Blacklist_Root=/etc/modprobe.d/nvidia-installer-disable-nouveau.conf

# Reboot System
var_auto_reboot=false
if [ ! -f ${Nouveau_Blacklist_Root} ]; then
    var_auto_reboot=true
fi

if [ ${var_auto_reboot} = true ]; then
    # Update Source
    sudo apt-get update

    echo '# generated by nvidia-installer' > ${Nouveau_Blacklist_Root}
    echo 'blacklist nouveau' >> ${Nouveau_Blacklist_Root}
    echo 'options nouveau modeset=0' >> ${Nouveau_Blacklist_Root}
    sudo update-initramfs -u
fi

# Install Basic Env
sudo apt-get install -y build-essential cmake

# CUDA Install 
sudo bash ${cur_workdir}/cuda_*_*_linux.run --driver --toolkit --no-opengl-libs --run-nvidia-xconfig --override --silent

if [ ${var_auto_reboot} = true ]; then
    echo_error "Please rerun this script after reboot ! ! !"
    read -n1 -sp "Press any key except 'ESC' to reboot: " var_ikey
    case ${var_ikey:=*} in
        $'\e') 
            echo_success "Reboot has been canceled"
        ;;
        *) 
            sudo reboot now
        ;;
    esac
else
    # CUDA Env
    CUDA_Profile_Root=/etc/profile.d/cuda.sh
    CUDA_HOME=/usr/local/cuda
    echo "export CUDA_HOME=${CUDA_HOME}" > ${CUDA_Profile_Root}
    echo 'export PATH=$CUDA_HOME/bin:$PATH' >> ${CUDA_Profile_Root}
    echo 'export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH' >> ${CUDA_Profile_Root}
    echo 'export INCLUDE=$CUDA_HOME/include:$INCLUDE' >> ${CUDA_Profile_Root}
    source ${CUDA_Profile_Root}

    # CUDA Conf Env
    CUDA_Conf_Root=/etc/ld.so.conf.d/cuda.conf
    echo '/usr/local/cuda/lib64' > ${CUDA_Conf_Root}
    sudo ldconfig

    # Cudnn Install 
    sudo tar -zxvf ${cur_workdir}/cudnn-*.tgz -C /usr/local
    
    read -n1 -sp "Press any key except 'ESC' to launch desktop: " var_ikey
    case ${var_ikey:=*} in
        $'\e') 
            echo_success "Reboot has been canceled"
        ;;
        *) 
            sudo service lightdm start
        ;;
    esac

fi
