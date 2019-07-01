#Custom Build Script

###############################################
#                                             #
# OCTOPUS PROJECT-X KERNEL REDMI NOTE 4X/MIDO #
# COMPILING WITH GCC-10 AND CLANG-5484270     #
#                                             #
###############################################


#
# - 2019 - Modification by me "Octo O", to support my compiler device
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#


# Color Code Script
green='\033[01;32m'
red='\033[01;31m'
cyan='\033[01;36m'
blue='\033[01;34m'
blink_red='\033[05;31m'
restore='\033[0m'
nocol='\033[0m'


# Init Script
LC_ALL=C date +%Y-%m-%d
date=`date +"%Y%m%d-%H%M"`
BUILD_START=$(date +"%s")
KERNEL_DIR=$PWD
ZIP_FOLDER=build
REPACK_DIR=$KERNEL_DIR/AnyKernel3
OUT=$KERNEL_DIR/out
export ARCH=arm64
export SUBARCH=arm64

# Compiler machnine
export CROSS_COMPILE="/home/octo/Kernel/aarch64-linux-gnu/bin/aarch64-linux-gnu-"
export CLANG_TCHAIN="/home/octo/Kernel/clang-5484270/bin/clang"

# Make your kernel string more sexier
export KBUILD_COMPILER_STRING="$(${CLANG_TCHAIN} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"

# Tweakable Stuff ( user@host blablabla )
export KBUILD_BUILD_USER="ExGurita"
export KBUILD_BUILD_HOST="LineageOS"
KERNEL_CODE="DELTA"
VERSION=`date +"%Y%m%d"`

# Compiling begin here

echo -e "$green"
echo "-------------------------------------------------------------"
echo "      Initializing build to compile Version: $KERNEL_CODE    "
echo "-------------------------------------------------------------"


echo -e "$blink_red***********************************************"
echo "          Removed previous zip file        "
echo -e "***********************************************$nocol"
rm $ZIP_FOLDER/*.zip


echo -e "$blink_red***********************************************"
echo "          Initialising DEFCONFIG        "
echo -e "***********************************************$nocol"
make O=out mido_defconfig


echo -e "$blink_red***********************************************"
echo "          Compiling Kernel        "
echo -e "***********************************************$nocol"
make -j$(nproc --all) O=out ARCH=arm64 \
                      CC="/home/octo/Kernel/clang-5484270/bin/clang" \
                      CLANG_TRIPLE="aarch64-linux-gnu-" \
                      CROSS_COMPILE="/home/octo/Kernel/aarch64-linux-gnu/bin/aarch64-linux-gnu-"


echo -e "$blink_red***********************************************"
echo "          Copying zImage        "
echo -e "***********************************************$nocol"
cd $REPACK_DIR
cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR/



echo -e "$blink_red***********************************************"
echo "          Making Flashable Zip        "
echo -e "***********************************************$nocol"
FINAL_ZIP="mido-octopusx-${VERSION}.zip"
zip -r9 "${FINAL_ZIP}" *
cp *.zip $OUT
rm *.zip
cd $KERNEL_DIR
rm AnyKernel3/Image.gz-dtb
mv $OUT/*.zip $ZIP_FOLDER/


BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$blink_red Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
