# Allwinner A733 octa core 4-16GB RAM WiFi6/BT UFS/eMMC microSD
BOARD_NAME="Orange Pi Zero 3W"
BOARD_VENDOR="xunlong"
BOARDFAMILY="sun60iw2"
BOARD_MAINTAINER="shkolnik"
INTRODUCED="2025"
KERNEL_TARGET="vendor"
KERNEL_TEST_TARGET="vendor"
IMAGE_PARTITION_TABLE="msdos"
HAS_VIDEO_OUTPUT="no" # no desktop on this vendor kernel; board-level so the build-list inventory sees it

BOOT_FDT_FILE="allwinner/sun60i-a733-orangepi-zero3w.dtb"
SUNXI_BOOT0_SDCARD_FEX="${SRC}/packages/blobs/sunxi/sun60iw2/boot0_sdcard_orangepizero3w.fex"
SUNXI_BOOT0_SPINOR_FEX="${SRC}/packages/blobs/sunxi/sun60iw2/boot0_sdcard_orangepizero3w.fex"
SUNXI_SYS_CONFIG_FEX="${SRC}/packages/blobs/sunxi/sun60iw2/sys_config_orangepi.fex"

# AIC8800D80 combo: BT is UART HCI on ttyS1 and needs userspace bring-up
SUN60IW2_UART_BT="yes"

# Invalidate U-Boot cache if any of the blobs change
UBOOT_HASH_EXTRA="$(cat "${SUNXI_BOOT0_SDCARD_FEX}" "${SUNXI_SYS_CONFIG_FEX}" | sha256sum | cut -d' ' -f1)"

# Vendor U-Boot SD/eMMC install offsets (boot0_sdcard.fex at 8 KiB,
# boot_package.fex at 16400 KiB). Overrides the family default which is
# Radxa-specific. Literal offsets: this runs board-side (armbian-install /
# u-boot upgrade) via `declare -f`, so family/board vars are absent.
function write_uboot_platform() {
	local SCRIPT_DIR="$1" DEVICE="$2"
	[[ -f "${SCRIPT_DIR}/boot0_sdcard.fex" ]] || { echo "write_uboot_platform: missing ${SCRIPT_DIR}/boot0_sdcard.fex" >&2; return 1; }
	[[ -f "${SCRIPT_DIR}/boot_package.fex" ]] || { echo "write_uboot_platform: missing ${SCRIPT_DIR}/boot_package.fex" >&2; return 1; }
	dd conv=notrunc,fsync status=none if="${SCRIPT_DIR}/boot0_sdcard.fex" of="${DEVICE}" bs=1k seek=8 ||
		{ echo "write_uboot_platform: boot0_sdcard.fex write to ${DEVICE} failed" >&2; return 1; }
	dd conv=notrunc,fsync status=none if="${SCRIPT_DIR}/boot_package.fex" of="${DEVICE}" bs=1k seek=16400 ||
		{ echo "write_uboot_platform: boot_package.fex write to ${DEVICE} failed" >&2; return 1; }
	sync "${DEVICE}"
}
