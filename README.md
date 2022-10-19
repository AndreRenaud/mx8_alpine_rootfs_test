# Booting


## Downloading via TFTP
```sh
Verdin iMX8MP # setenv bootargs console=ttymxc2,115200 root=/dev/ram && setenv autoload n && bootp && tftp $loadaddr 192.168.1.16:ed10m.itb && bootm $loadaddr
```

## Loading onto Flash


# Video output

