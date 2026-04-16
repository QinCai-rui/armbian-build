# Allwinner octa core 2xA76 6xA55 2-16GB LPDDR5
BOARD_NAME="radxa cubie a7s"
BOARDFAMILY="sun60iw2"
BOARD_MAINTAINER=""
KERNEL_TARGET="legacy,vendor"
UBOOT_EXTLINUX_ROOT="root=UUID=%%ROOT_PARTUUID%%"
BOOT_FDT_FILE="allwinner/sun60i-a733-cubie-a7s.dtb"
OVERLAY_PREFIX="sun60i-a733"
IMAGE_PARTITION_TABLE="gpt"
BOOTFS_TYPE="fat"

enable_extension "radxa-aic8800"
AIC8800_TYPE="usb"
enable_extension "radxa-bxm-img-gpu"
