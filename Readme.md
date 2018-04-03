# Mxnet Install Shell Script [MISS]
MISS is a very friendly script to deploy [CUDA Env](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/) and [Mxnet](https://github.com/apache/incubator-mxnet) 

## Installation
### CUDA Installation[GPU Option]
> * Auto Disable `Nouveau`
> * Auto Install [Nvidia Driver](http://www.nvidia.com/drivers)[Default Included in CUDA Kit]
> * Auto Install [CUDA](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/) & [CUDNN Kit](https://developer.nvidia.com/cudnn)

> | OS                                                              | Tested      |
> |-----------------------------------------------------------------|-------------|
> | [Centos 7](https://www.centos.org/download/)                    | √           |
> | [Docker [GPU]](https://github.com/NVIDIA/nvidia-docker)         | √           |
> | Ubuntu 14.04.5 LTS                                              | √           |
> | [Ubuntu 16.04.3~4 LTS](https://www.ubuntu.com/download/desktop) | √           |


* **Make sure u had download the [CUDA](https://developer.nvidia.com/cuda-toolkit-archive) &amp; [CUDNN](https://developer.nvidia.com/rdp/cudnn-download) Before Installation**  
* **Switch the terminal by `Ctrl + Alt + F1~F6`**
* **`Script may need to run twice`**
* **[[Ubuntu Desktop](https://www.ubuntu.com/download/desktop) OS are recommended to disable auto Update]  
`System Settings` -> `Software & Updates` -> `Updates` -> `[Download and install automatically] -> [Display immediately]`**

```bash
   sudo bash Install_CUDA.sh
```
----

### Evn Installation
> * Auto Deploy Basic Software
> * Auto Install Python2 & Python3 Plugins
> * Extract [Pycharm](https://www.jetbrains.com/pycharm/)[Option]
> * **Export Mxnet Env**

```bash
    sudo bash Install_Env.sh
```

### Mxnet Installation
> * Auto Install Mxnet with Warp-CTC
> * **Make sure u had [`Mxnet` `Warp-CTC`](https://github.com/alues/Mxnet_Install_Script/blob/master/Mxnet/Readme.md) Ready Before Installation**

```bash
    sudo bash Install_Mxnet.sh
```
