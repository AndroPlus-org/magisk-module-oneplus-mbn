#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode

ensure_newline_end () {
  tail -c 1 "$1" | read -r _ || echo '' >> "$1"
}

MCFG_PATH=/vendor/firmware_mnt/image/modem_pr/mcfg/configs/mcfg_sw
DATA_MCFG_PATH=/data/vendor/modem_config
MBN_FILES="
mcfg_sw/generic/APAC/DCM/pixel_Commercial/mcfg_sw.mbn
mcfg_sw/generic/APAC/KDDI/pixel_Commercial/mcfg_sw.mbn
mcfg_sw/generic/APAC/Rakuten/pixel_Commercial/mcfg_sw.mbn
mcfg_sw/generic/APAC/SBM/pixel_Commercial/mcfg_sw.mbn
"
MCFG_MODPATH=${MODDIR}/system${MCFG_PATH}

add_mcfg () {
	SOURCE_LIST=${MCFG_PATH}/$1
	if [ -e "$SOURCE_LIST" ]; then
		TARGET_LIST=$MCFG_MODPATH/$1
		cp "$SOURCE_LIST" "$TARGET_LIST"
		ensure_newline_end "$TARGET_LIST"
		for MBNFILE in $MBN_FILES; do
			if grep -qF "$MBNFILE" "$TARGET_LIST"; then
				echo "Skip $MBNFILE"
			else
				echo "Adding $MBNFILE to $TARGET_LIST" >> /cache/magisk.log
				echo "$MBNFILE" >> "$TARGET_LIST"
			fi
			SOURCE_MBN=$MCFG_MODPATH/../$MBNFILE
			TARGET_MBN=$DATA_MCFG_PATH/$MBNFILE
			echo "Copying $(realpath $SOURCE_MBN) to $TARGET_MBN" >> /cache/magisk.log
			mkdir -p "$(dirname $TARGET_MBN)"
			cp "$(realpath $SOURCE_MBN)" "$TARGET_MBN"
		done
	fi
}

add_mcfg "mbn_sw.txt"
add_mcfg "oem_sw.txt"
add_mcfg "oem_sw_a.txt"
add_mcfg "oem_sw_w.txt"
add_mcfg "oem_sw_all.txt"
add_mcfg "oem_sw_comm.txt"
