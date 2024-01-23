Zybo Z7 SD Card image generator
=====

This project contains cmake and dependent bash scripts for de0-nano-soc Debian boot SD-Card.

 Prerequisite
===============

1. Linux (Debian 12) host (amd64) as development host (dev-host).
2. Multiarch for armhf enabled on the dev-host.
3. QEMU arm installed on dev-host.

 Dependent Debian packages
===========================

```
sudo dpkg --add-architecture armhf
sudo apt update
sudo apt upgrade
sudo apt-get -y install crossbuild-essential-armhf
sudo apt-get -y install bc build-essential cmake dkms git libncurses5-dev
sudo apt-get -y install u-boot-tools
sudo apt-get -y install qemu-system-arm
(Maybe some else...)
```

 Procedure
===========================

## Get u-boot and Linux kernel source tree on the sibling directory to zync_debian

```shell
git clone https://github.com/Xilinx/u-boot-xlnx.git
git clone https://github.com/Xilinx/linux-xlnx
```

## Prepare prerequisite binaries

### Build u-boot

```shell
cd u-boot-xlnx
git checkout xilinx-v2023.2
```

#### Quck dirty fix for reading mac address on zybo-z7 board (optional)
```shell
patch -p1 < ../zynq_debian/u-boot-patch/u-boot_2023.2_z7_macaddr_qspi.patch
```
#### Configure and build u-boot for zynq-zybo-z7
```shell
make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm xilinx_zynq_virt_defconfig
```
```shell
DEVICE_TREE=zynq-zybo-z7 make CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm -j4
```

## Create boot.scr boot script binary

The following commands will create boot.scr from boot.cmd under the zynq_debian/src/ directory.

```shell
cd ../zynq_debian/src
make
```

### Build linux kernel

```shell
cd ../linux-xlnx
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- xilinx_zynq_defconfig
```
```shell
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8 zImage
```
```shell
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8 all
```

## Build root filesystem (if not done yet) and SD Card image file

Review the 'config.cmake' file and edit if necessary.

Under the project directory (zynq_debian), create the build directory 'mkdir build' and change its directory.
Run cmake as 'cmake <zynq_debian source directory>.'

1. run 'make' will create the Debian root file system.  This process requires root privilege due to elevated commands in script files.
The above make run will create the Debian root filesystem using "bootstrapping."
1. In the middle of the script, it shows two lines of command, which the user needs to run on the console.
1. run 'make img' to make the SD Card image file.  This step also requires root privilege for internal use of the 'sudo' command.

## Fix /etc/network/interface file

Depending on the Debian version, the interface name was changed to **end0** rather than **eth0**.  Adjust /etc/network/interface file when necessary.

## Fix x86_64 binary installed on the target device

However, Debian provides a method to build a custom Linux-header deb package that contains x86_64 binaries under scripts, which will cause a problem when installing the DKMS package.  A dirty quick fix is as follows:

1. Copy kernel source (linux-xlnx etc.) under /usr/src/ on target filesystem (e.g. `tar --exclude=./linux-xlnx/.git -cvf linux-xlnx.tar ./linux-xlns`)
2. Run ```make scripts``` and ```make modules_prepare``` at top directory of the kernel source on the target.


Eth: 00:18:3e:03:73:11
