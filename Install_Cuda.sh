#!bin/bash

cur_path=$(cd "$(dirname "$0")"; pwd)
cur_workdir=${cur_path}/Nvidia_CUDA
cur_sys=`cat /etc/*-release | sed -r "s/^ID=(.*)$/\\1/;tA;d;:A;s/^\"(.*)\"$/\\1/"`

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

function service_detect(){
    tmp_status=`service --status-all | sed -r "s/^\s*\[\s*[+|-]\s*\]\s*${1}\$/0/;tA;d;:A;"`
    return ${tmp_status:-1}
}

CUDA_Kit_list=(
    # CUDA
    cuda_*_*_linux.run
    # CUDNN
    cudnn-*.tgz
)

# Dectect CUDA & CUDNN 
for v in ${CUDA_Kit_list[@]}; do
    if [ ! -e ${cur_workdir}/${v} ]; then
        echo_error 'Please make sure u had download CUDA & CUDNN Kit'
        echo_success "Problem could be solved by reading ${cur_workdir}/readme.md"
        echo_error "${cur_workdir}/${v} Needed"
        exit 1
    fi
done

# Detect Desktop Service
Desktop_Service=false
case ${cur_sys} in
    "ubuntu")
        Desktop_Service=$(service_detect "lightdm")
        if ${Desktop_Service}; then
            sudo service lightdm stop
        fi
    ;;
    "centos")
        
    ;;
esac

# Disable the Nouveau
Nouveau_Blacklist_Root=/etc/modprobe.d/nvidia-installer-disable-nouveau.conf

# Reboot System
if [ ! -e ${Nouveau_Blacklist_Root} ]; then
    var_auto_reboot=true
fi

if [ ${var_auto_reboot:=false} = true ]; then
    echo '# generated by nvidia-installer' > ${Nouveau_Blacklist_Root}
    echo 'blacklist nouveau' >> ${Nouveau_Blacklist_Root}
    echo 'options nouveau modeset=0' >> ${Nouveau_Blacklist_Root}

    case ${cur_sys} in
        "ubuntu")
            # Update Source
            sudo apt-get update
            sudo update-initramfs -u
        ;;
        "centos")
            sudo dracut --force
        ;;
    esac
fi

# Install Basic Env
case ${cur_sys} in
    "ubuntu")
        sudo apt-get install -y dkms linux-headers-$(uname -r) build-essential cmake
    ;;
    "centos")
        sudo yum install -y epel-release
        sudo yum install -y dkms kernel-headers-$(uname -r) kernel-devel-$(uname -r) cmake
    ;;
esac

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
            case ${cur_sys} in
                "ubuntu")
                    if ${Desktop_Service}; then
                        sudo service lightdm start
                    fi
                ;;
                "centos")
                    
                ;;
            esac
        ;;
    esac

fi
