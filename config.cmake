
set( distro "buster" )
set( target "zynq" )
set( cross_target "armhf" )
set( target_device "zybo-z7" )

get_filename_component( topdir "${CMAKE_SOURCE_DIR}" DIRECTORY )

set( U_BOOT_DIR "${topdir}/FPGA-SoC-Linux/target/zynq-zybo-z7/boot" )
set( KERNEL_SOURCE "${topdir}/linux-xlnx" )

set ( DTB "${U_BOOT_DIR}/devicetree-5.4.105-zynq-zybo-z7.dtb" )
set ( DTS "${U_BOOT_DIR}/devicetree-5.4.105-zynq-zybo-z7.dts" )

set ( BOOT_FILES
  ${U_BOOT_DIR}/boot.bin
  ${U_BOOT_DIR}/u-boot.img
  ${DTB}
  )

foreach( f ${BOOT_FILES} )
  if ( EXISTS ${f} )
    message( STATUS "boot file: " ${f} )
  else()
    message( FATAL "boot file: " ${f} " not found" )
  endif()
endforeach()
