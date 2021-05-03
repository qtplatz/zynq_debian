#
cmake_minimum_required ( VERSION 3.7 )  # for GREATER_EQUAL
cmake_policy( SET CMP0020 NEW )
cmake_policy( SET CMP0042 NEW )
cmake_policy( SET CMP0053 NEW )

project (zynq_debian)

list( APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules" )

include(config.cmake)

set ( TOOLS ${CMAKE_SOURCE_DIR}/scripts )

#------------------------ debian rootfs ----------------
set ( ROOTFS ${CMAKE_BINARY_DIR}/arm-linux-gnueabihf-rootfs-${distro} )

add_custom_command(
  OUTPUT ${ROOTFS}
  COMMAND distro=${distro} targetdir=${ROOTFS} ${CMAKE_SOURCE_DIR}/scripts/debootstrap.sh
  )

add_custom_target( rootfs ALL DEPENDS ${ROOTFS} ${CMAKE_SOURCE_DIR}/CMakeLists.txt )
#------------------------ end debian rootfs ----------------

#------------- SDCard image ---------------
find_file( KERNELIMAGE "zImage" HINTS "${KERNEL_SOURCE}/arch/arm/boot" )

if ( KERNELIMAGE )
  list ( APPEND BOOT_FILES ${KERNELIMAGE} )
endif()

if ( EXISTS "${KERNEL_SOURCE}/.config" )
  list ( APPEND BOOT_FILES "${KERNEL_SOURCE}/.config" )
else()
  message( FATAL_ERROR "Either ${KERNEL_SOUCE} does not exist or not yet configured." )
endif()

execute_process( COMMAND make kernelversion
  OUTPUT_VARIABLE KERNELRELEASE
  WORKING_DIRECTORY ${KERNEL_SOURCE}
  OUTPUT_STRIP_TRAILING_WHITESPACE )

#----------------------- .img file --------------------
set ( MNT_BOOTFS "/mnt/bootfs" )
set ( MNT_ROOTFS "/mnt/rootfs" )
set ( IMGFILE ${CMAKE_BINARY_DIR}/${target}_${distro}-${KERNELRELEASE}-dev.img )
#<----------------------- .img file --------------------

include ( mkimage )
add_custom_target( img DEPENDS ${IMGFILE} ${BOOT_FILES} ${PACKAGES} VERBATIM )

#------------- end SDCard image ---------------

message( STATUS "--------------------------------------------" )
message( STATUS "KERNELRELEASE   = " ${KERNELRELEASE} )
message( STATUS "KERNEL_SOURCE   = " ${KERNEL_SOURCE} )
message( STATUS "distro          = " ${distro} )
message( STATUS "cross_target    = " ${cross_target} )
message( STATUS "target_device   = " ${target_device} )
message( STATUS "ROOTFS          = " ${ROOTFS} )
message( STATUS "IMGFILE         = " ${IMGFILE} )
message( STATUS "BOOT_FILES        " )
foreach( i ${BOOT_FILES} )
  message( STATUS "\t\t${i}" )
endforeach()
message( STATUS "target_device   = " ${target_device} )
message( STATUS "--------------------------------------------" )
if ( DEFINED MBR )
  message( STATUS "============ Notice ===========
-- You must run following command after 'make img' (replacing u-boot)
    bzcat ${MBR} | sudo dd of=/dev/loop0p3 bs=1024
-- before 'make umount.'
-- ======== End of Notice ========")
endif()
