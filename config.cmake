
set( distro "buster" )
set( target "zynq" )
set( cross_target "armhf" )
set( target_device "zybo-z7" )

get_filename_component( topdir "${CMAKE_SOURCE_DIR}" DIRECTORY )

#set( U_BOOT_DIR "${topdir}/FPGA-SoC-Linux/target/zynq-zybo-z7/boot" )
set( U_BOOT_DIR "${topdir}/u-boot-xlnx" )
set( KERNEL_SOURCE "${topdir}/linux-xlnx" )

set ( DTB             "${U_BOOT_DIR}/u-boot.dtb" )
set ( DTS             "${U_BOOT_DIR}/arch/arm/dts/zynq-zybo-z7.dts" )
set ( U-BOOT_BOOT_BIN "${U_BOOT_DIR}/spl/boot.bin" )
set ( U_BOOT_IMG      "${U_BOOT_DIR}/u-boot.img" )

set ( BOOT_SCR        "${CMAKE_SOURCE_DIR}/src/boot.scr" )
set ( BOOT_CMD        "${CMAKE_SOURCE_DIR}/src/boot.cmd" )

set ( BOOT_FILES
  ${U_BOOT_BOOT_BIN}
  ${U_BOOT_IMG}
  ${DTB}
  ${BOOT_SCR}
  ${BOOT_CMD}
  )

foreach( f ${BOOT_FILES} )
  if ( EXISTS ${f} )
    message( STATUS "boot file: " ${f} )
  else()
    message( FATAL "boot file: " ${f} " not found" )
  endif()
endforeach()
