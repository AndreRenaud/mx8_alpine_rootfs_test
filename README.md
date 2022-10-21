# Booting

## Running from SD Card

fatload mmc 2 $loadaddr Image.gz
fatload mmc 2 $fdt_addr_r imx8mp-verdin-wifi-dev.dtb
setenv bootargs console=ttymxc2,115200 root=/dev/mmcblk2p2
booti $loadaddr - $fdt_addr_r

## Downloading via TFTP
```sh
Verdin iMX8MP # setenv bootargs console=ttymxc2,115200 root=/dev/ram video=HDMI-A-1:1280x720-16@60D && setenv autoload n && bootp && tftp $loadaddr 192.168.1.31:ed10m.itb && bootm $loadaddr
```

## Loading onto Flash


# Video output

SDL_VIDEODRIVER=kmsdrm /tmp/simple_example
