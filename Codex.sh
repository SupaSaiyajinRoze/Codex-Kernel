#!/bin/bash
#

# Init Script
KERNEL_DIR=$PWD
KERNEL="Image.gz-dtb"
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
BASE_VER="Codex"
VER="-v1-$(date +"%Y-%m-%d"-%H%M)-"
BUILD_START=$(date +"%s")


# Tweakable Stuff
export ARCH=arm64
export CROSS_COMPILE=/home/axel/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export JOBS=16
export SUBARCH=arm
export KBUILD_BUILD_USER="Axel"
export KBUILD_BUILD_HOST="Codex-Kernel"


#COMPILATION SCRIPTS
echo "--------------------------------------------------------"
echo "      Initializing build to compile Ver: $VER    "
echo "--------------------------------------------------------"

echo -e "***********************************************"
echo "          Compiling Codex!!      "
echo -e "***********************************************"

rm -f $KERN_IMG

echo -e "***********************************************"
echo "          Cleaning Up Before Compile          "
echo -e "***********************************************"

$clean rm -rf out && mkdir out

echo -e "***********************************************"
echo "          Initialising DEFCONFIG        "
echo -e "***********************************************"

make -C $PWD O=$PWD/out ARCH=arm64 halcyon_defconfig

echo -e "***********************************************"
echo "          Cooking Codex_kernel!!        "
echo -e "***********************************************"

make -j$JOBS -C $PWD O=$PWD/out ARCH=arm64 KCFLAGS=-mno-android

if ! [ -a $ZIMAGE ];
then
echo -e " Kernel Compilation failed! Fix the errors! "
exit 1
fi


#BUILD TIME
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e " Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
