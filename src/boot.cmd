#!/bin/bash
# Recompile with:
# mkimage -C none -A arm -T script -d boot.cmd boot.scr
#env set bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait fsck.repair=yes panic=10
# load load mmc 0:1 ${scriptaddr} boot.scr
env set bootargs root=/dev/mmcblk0p2 rw
fatload mmc 0 ${kernel_addr_r} zImage
fatload mmc 0 ${fdt_addr_r} u-boot.dtb
bootz ${kernel_addr_r} - ${fdt_addr_r}
