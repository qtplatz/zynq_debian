Zybo Z7 SD Card image generator
=====

This project contains cmake and dependent bash scripts for de0-nano-soc debian boot SD-Card.

 Prerequisite
===============

1. Linux (debian10) host (amd64).
2. Multiarch for armhf enabled on host.
3. QEMU arm

 Dependent debian packages
===========================

```
sudo dpkg --add-architecture armhf
sudo apt-get -y install crossbuild-essential-armhf
sudo apt-get -y install bc build-essential cmake dkms git libncurses5-dev
(May be some else...)
```

 Procedure
===========================

## Get u-boot and Linux kernel source tree on the sibling directory to zync_debian

```shell
git clone https://github.com/Xilinx/u-boot-xlnx.git
git clone https://github.com/Xilinx/linux-xlnx
```

## Build u-boot

Reference: [Build U-Boot](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841973/Build+U-Boot#BuildU-Boot-ConfiguringU-Boot(%3E%3D2020.1Release))

```shell
cd u-boot-xlnx
make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm xilinx_zynq_virt_defconfig
DEVICE_TREE="zynq-zybo-z7" make
```

Under the project directory (zynq_debian), create build directory 'mkdir build', and change directory in it.
Run cmake as 'cmake <zynq_debian-directory>'.

Makefile will be generated, then
1. run 'make' will create Debian root file system.  This process requires root privilege due to elevated command is in script files. After 'rootfs' was created, then
1. run 'make img' to make SD Card image file.  This step also requires root privilege for 'sudo' command.
