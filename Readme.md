# Mxnet Install Shell Script

> ## CUDA Installation[GPU Option]
> * Auto Disable `Nouveau`
> * Auto Install [Nvidia Driver](http://www.nvidia.com/drivers)[Default Included in CUDA Kit]
> * Auto Install [CUDA](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/) & [CUDNN Kit](https://developer.nvidia.com/cudnn)

> > ### Tested OS
> > - [x] Centos 7
> > - [x] Ubuntu 14.04.5 LTS
> > - [x] [Ubuntu 16.04.3 LTS](https://www.ubuntu.com/download/desktop)

> * **Make sure u had download the [CUDA](https://developer.nvidia.com/cuda-toolkit-archive) &amp; [CUDNN](https://developer.nvidia.com/rdp/cudnn-download) Before Installation**  
> * **Switch the terminal by `Ctrl + Alt + F1`**
> * **`Script may need to run twice`**

> ```bash
>    sudo bash Install_CUDA.sh
> ```

----

> ## Evn Installation
> * Auto Deploy Basic Software
> * Auto Install Python2 & Python3 Plugins
> * Extract [Pycharm](https://www.jetbrains.com/pycharm/)[Option]
> * Export Mxnet Env

```bash
    sudo bash Install_Env.sh
```

> ## Mxnet Installation
> * Auto Install Mxnet with Warp-CTC

* **Make sure u had [`Mxnet` `Warp-CTC`](https://github.com/alues/Mxnet_Install_Script/blob/master/Mxnet/Readme.md) Ready Before Installation**

```bash
    sudo bash Install_Mxnet.sh
```
