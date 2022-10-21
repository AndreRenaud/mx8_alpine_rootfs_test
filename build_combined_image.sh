#!/bin/bash -e

BASE=$(dirname $(realpath $0))
KERNEL_DIR=$(realpath ${BASE}/../linux-toradex)

DTB=arch/arm64/boot/dts/freescale/imx8mp-verdin-wifi-dev.dtb
IMAGE=arch/arm64/boot/Image

if [ ! -f "${KERNEL_DIR}/${DTB}" ] ; then
    echo "Kernel doesn't appear to be built" >&2
    exit 1
fi

if [ -d "image_output" ] ; then
    rm -rf image_output
fi

# Grab the rootfs + kernel files & combine into a single image
mkdir -p image_output
echo "Combining $KERNEL_DIR/$IMAGE, $KERNEL_DIR/$DTB and initramfs into image_output/ed10m.itb"
cp "${KERNEL_DIR}/${IMAGE}" "${KERNEL_DIR}/${DTB}"  image_output/
cp initramfs image_output/

mkimage -q -f ed10m.its image_output/ed10m.itb

mkimage -l image_output/ed10m.itb

echo "Final image"
du -sh image_output/ed10m.itb