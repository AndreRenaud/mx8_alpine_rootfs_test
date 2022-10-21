#!/bin/bash

set -e

ROOT=alpine_root
INITRAMFS=`pwd`/initramfs

if [ -f alpine-minirootfs-3.16.2-aarch64.tar.gz ] ; then
	echo "Skipping download of minitroofs - already exists"
else
	wget https://dl-cdn.alpinelinux.org/alpine/v3.16/releases/aarch64/alpine-minirootfs-3.16.2-aarch64.tar.gz
fi

if [ -d "$ROOT" ] ; then
	echo "Erasing old root $ROOT"
	sudo rm -irf "$ROOT"
fi
mkdir "$ROOT"
sudo tar -C "$ROOT" -xf alpine-minirootfs-3.16.2-aarch64.tar.gz

cat > "custom_setup.sh" << EOF
#!/bin/sh
echo nameserver 1.1.1.1 > /etc/resolv.conf
echo "ed10m" > /etc/hostname
cat > /etc/inittab << MYEOF
::sysinit:/sbin/openrc sysinit
::sysinit:/sbin/openrc boot
::wait:/sbin/openrc default
console::respawn:/sbin/getty -L console 115200 vt100
::ctrlaltdel:/sbin/reboot
::shutdown:/sbin/openrc shutdown
MYEOF
printf "auto lo\niface lo inet loopback\n" > /etc/network/interfaces
ln -s /sbin/init /init
printf "root\nroot" | passwd root
apk update
apk add dropbear util-linux-misc mdevd-openrc wpa_supplicant wireless-tools wireless-regdb ca-certificates openrc linux-firmware-imx
apk add glmark2
rc-update add dropbear
rc-update add mdevd
cat > /etc/motd << MYEOF
Welcome to ED10M
MYEOF
EOF
sudo mv custom_setup.sh "$ROOT/"
sudo chmod +x "$ROOT/custom_setup.sh"
sudo chroot "$ROOT" /custom_setup.sh
sudo rm "$ROOT/custom_setup.sh"

pushd "$ROOT"
# Uncomment this one instead for better compression ratio (much slower compression speed though)
#ZSTD_FLAGS="--ultra -T0 -22"
# sudo find . -print0 | sudo cpio --null -o --owner 0:0 --format=newc | zstd $ZSTD_FLAGS > "$INITRAMFS"
# Note:  LZ4 decompressor isn't available on this older kernel
sudo find . -print0 | sudo cpio --null -o --owner 0:0 --format=newc | gzip > "$INITRAMFS"
popd

du -sh "$INITRAMFS"

