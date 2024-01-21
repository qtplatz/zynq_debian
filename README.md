Zybo Z7 SD Card image generator
=====

This project contains cmake and dependent bash scripts for de0-nano-soc Debian boot SD-Card.

 Prerequisite
===============

1. Linux (debian10) host (amd64).
2. Multiarch for armhf enabled on host.
3. QEMU arm

 Dependent Debian packages
===========================

```
sudo dpkg --add-architecture armhf
sudo apt update
sudo apt upgrade
sudo apt-get -y install crossbuild-essential-armhf
sudo apt-get -y install bc build-essential cmake dkms git libncurses5-dev
sudo apt-get -y install u-boot-tools
(May be some else...)
```

 Procedure
===========================

## Get u-boot and Linux kernel source tree on the sibling directory to zync_debian

```shell
git clone https://github.com/Xilinx/u-boot-xlnx.git
git clone https://github.com/Xilinx/linux-xlnx
```

The versions for the repositories as of writing this was:
```
xilinx-v2020.2-7997-g57460e4a93
zynqmp-soc-fixes-for-v5.10-rc6-13549-g17d102b6645d
```

## Prepare prerequisite binaries

### Build u-boot

```shell
cd u-boot-xlnx
patch -p1 < ../zynq_debian/u-boot-patch/u-boot_2021.04_z7_macaddr_qspi.patch
make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm xilinx_zynq_virt_defconfig
DEVICE_TREE=zynq-zybo-z7 make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm -j4
```

## Create boot.scr boot script binary

Following commands will create boot.scr from boot.cmd under zynq_debian/src/ directory.

```shell
cd ../zynq_debian/src
make
```

### Build linux kernel

```shell
cd ../linux-xlnx
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- xilinx_zynq_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8 zImage
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8 all
```

## Build root filesystem (if not done yet) and SD Card image file

Under the project directory (zynq_debian), create the build directory 'mkdir build' and change its directory.
Run cmake as 'cmake <zynq_debian source directory>'.

1. run 'make' will create the Debian root file system.  This process requires root privilege due to elevated command is in script files.
Above make run will create the Debian root filesystem using "debootstraping."
1. run 'make img' to make the SD Card image file.  This step also requires root privilege for internal use of the 'sudo' command.

## Fix x86_64 binary installed on the target device

Although, Debian provide a method bo build custom linux-header deb package, that contains x86_64 binaries under scripts, that will cause a problem when install DKMS package.  Dirty quick fix is as following:

1. Copy kernel source (linux-xlnx etc.) under /usr/src/ on target filesystem (e.g. tar --exclude=./linux-xlnx/git -cvf linux-xlnx.tar ./linux-xlns)
2. Run ```make scripts``` and ```make modules_prepare``` at top directory of the kernel source on the target.
