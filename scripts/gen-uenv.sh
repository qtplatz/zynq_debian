#!/bin/bash
cat <<"EO"F>${outfile}
########################################################################
# Linux Kernel Files
#  * linux_kernel_image : Linux Kernel Image File Name
#  * linux_fdt_image    : Linux Device Tree Blob File Name
########################################################################
linux_kernel_image=zImage
linux_fdt_image=devicetree-5.4.105-zynq-zybo-z7.dtb

########################################################################
# Linux Boot Argments
#  * linux_boot_args_console : ex) console=tty1
#                                  console=ttyPS0,115200
#  * linux_boot_args_rootfs  : ex) root=/dev/mmcblk0p2 rw rootwait
#  * linux_boot_args_systemd : ex) systemd.unit=graphical.target
#                                  systemd.unit=multi-user.target
#  * linux_boot_args_cpuidle : ex) cpuidle.off=1
#  * linux_boot_args_cma     : ex) cma=256M
#  * linux_boot_args_uio     : ex) uio=uio_pdrv_genirq.of_id=generic-uio
#  * linux_boot_args_other   :
########################################################################
linux_boot_args_console=console=ttyPS0,115200
linux_boot_args_rootfs=root=/dev/mmcblk0p2 rw rootwait
linux_boot_args_systemd=
linux_boot_args_cpuidle=
linux_boot_args_cma=
linux_boot_args_uio=uio_pdrv_genirq.of_id=generic-uio
linux_boot_args_other=

########################################################################
# uenvcmd : During sdboot, if uenvcmd is set, uenvcmd will be executed.
########################################################################
linux_img_load_cmd=fatload mmc 0 ${kernel_addr_r} ${linux_kernel_image}
linux_fdt_load_cmd=fatload mmc 0 ${fdt_addr_r}    ${linux_fdt_image}
linux_load_cmd=env run linux_img_load_cmd && env run linux_fdt_load_cmd
linux_boot_cmd=bootz ${kernel_addr_r} - ${fdt_addr_r}
linux_args_cmd=if env exists linux_boot_args; then; setenv bootargs ${linux_boot_args}; else; setenv bootargs ${linux_boot_args_console} ${linux_boot_args_rootfs} ${linux_boot_args_systemd} ${linux_boot_args_cpuidle} ${linux_boot_args_cma} ${linux_boot_args_uio} ${linux_boot_args_other}; fi
uenvcmd=env run linux_args_cmd && env run linux_load_cmd && env run linux_boot_cmd

########################################################################
# external_env_file : external environment file.
# external_env_boot : import external_env_file and boot.
########################################################################
external_env_existence_test=test -e mmc 0 ${external_env_file}
external_env_load=fatload mmc 0 ${loadbootenv_addr} ${external_env_file}
external_env_import=env import -t ${loadbootenv_addr} $filesize
external_env_set=env run external_env_existence_test && env run external_env_load && env run external_env_import
external_env_boot=if env run external_env_set; then; boot; else; echo "## Error Read fail " ${external_env_file}; fi

########################################################################
# Boot Menu
########################################################################
bootmenu_0=Boot Default=boot
bootmenu_1=Boot linux-5.4.105-armv7-fpga=env set external_env_file uEnv-linux-5.4.105-armv7-fpga.txt && env run external_env_boot

EOF
