#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode

local MBN_LIST
local MBN_FILES

MBN_LIST="/vendor/firmware_mnt/image/modem_pr/mcfg/configs/mcfg_sw"
MBN_FILES="
mcfg_sw/generic/APAC/DCM/pixel_Commercial
mcfg_sw/generic/APAC/KDDI/pixel_Commercial
mcfg_sw/generic/APAC/Rakuten/pixel_Commercial
mcfg_sw/generic/APAC/SBM/pixel_Commercial
"

local MODPATH_LIST="${MODPATH}/system${MBN_LIST}/mbn_sw.txt"
cp "${MBN_LIST}/mbn_sw.txt" "$MODPATH_LIST"

# Add each path to mcfg_sw.mbn at the end of mbn_sw.txt
#           ONLY IF the path is NOT EXIST in mbn_sw.txt
echo "" >> "$MODPATH_LIST"
local MBNFILE
for MBNFILE in $MBN_FILES; do
grep -qF "$MBNFILE/mcfg_sw.mbn" "$MODPATH_LIST" || echo "$MBNFILE/mcfg_sw.mbn" >> "$MODPATH_LIST"
if [ -d /data/vendor/modem_config ]; then
	cp -ra "$MODPATH_LIST" "/data/vendor/modem_config/mcfg_sw/mbn_sw.txt"
	mkdir -p "/data/vendor/modem_config/${MBNFILE}"
	cp -ra "${MBN_LIST}/../${MBNFILE}" "/data/vendor/modem_config/${MBNFILE}/mcfg_sw.mbn"
fi
done


local MODPATH_LIST_OEM="${MODPATH}/system${MBN_LIST}/oem_sw.txt"
cp "${MBN_LIST}/oem_sw.txt" "$MODPATH_LIST_OEM"

# Add each path to mcfg_sw.mbn at the end of oem_sw.txt
#           ONLY IF the path is NOT EXIST in oem_sw.txt
echo "" >> "$MODPATH_LIST_OEM"
local MBNFILE_OEM
for MBNFILE_OEM in $MBN_FILES; do
grep -qF "$MBNFILE_OEM/mcfg_sw.mbn" "$MODPATH_LIST_OEM" || echo "$MBNFILE_OEM/mcfg_sw.mbn" >> "$MODPATH_LIST_OEM"
if [ -d /data/vendor/modem_config ]; then
	cp -ra "$MODPATH_LIST_OEM" "/data/vendor/modem_config/mcfg_sw/oem_sw.txt"
fi
done

# Extra files found on OnePlus 7
local MODPATH_LIST_OEM2="${MODPATH}/system${MBN_LIST}/oem_sw_a.txt"
if [ -e "${MBN_LIST}/oem_sw_a.txt" ]; then
	cp "${MBN_LIST}/oem_sw_a.txt" "$MODPATH_LIST_OEM2"

	# Add each path to mcfg_sw.mbn at the end of oem_sw.txt
	#           ONLY IF the path is NOT EXIST in oem_sw.txt
	echo "" >> "$MODPATH_LIST_OEM2"
	local MBNFILE_OEM
	for MBNFILE_OEM in $MBN_FILES; do
	grep -qF "$MBNFILE_OEM/mcfg_sw.mbn" "$MODPATH_LIST_OEM2" || echo "$MBNFILE_OEM/mcfg_sw.mbn" >> "$MODPATH_LIST_OEM2"
	done
fi

local MODPATH_LIST_OEM3="${MODPATH}/system${MBN_LIST}/oem_sw_w.txt"
if [ -e "${MBN_LIST}/oem_sw_w.txt" ]; then
	cp "${MBN_LIST}/oem_sw_w.txt" "$MODPATH_LIST_OEM3"

	# Add each path to mcfg_sw.mbn at the end of oem_sw.txt
	#           ONLY IF the path is NOT EXIST in oem_sw.txt
	echo "" >> "$MODPATH_LIST_OEM3"
	local MBNFILE_OEM
	for MBNFILE_OEM in $MBN_FILES; do
	grep -qF "$MBNFILE_OEM/mcfg_sw.mbn" "$MODPATH_LIST_OEM3" || echo "$MBNFILE_OEM/mcfg_sw.mbn" >> "$MODPATH_LIST_OEM3"
	done
fi