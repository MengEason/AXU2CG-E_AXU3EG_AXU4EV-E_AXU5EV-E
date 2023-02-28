#!/bin/bash

DEVICE=/dev/nvme0n1
DEVICE_NAME=${DEVICE##/dev/}p1
DEVICE_SECTOR="$DEVICE"p1

#check nvme device
if [ ! -e "$DEVICE" ];then
	echo no nvme device found 
	exit
fi

#check sector
CHECK_RST=`ls $DEVICE_SECTOR`
if [[ "$CHECK_RST" != "$DEVICE_SECTOR" ]];then
	#fdisk set sector
	echo "n
p
1


w
" | fdisk $DEVICE
	
	#mkfs.ext4 set fs
	echo "y

" | mkfs.ext4 $DEVICE_SECTOR
	echo "set SSD sector OK, add one sector $DEVICE_SECTOR"
else
	echo "SSD already have a sector $DEVICE_SECTOR"
fi

#check mount
CHECK_RST=`mount | grep $DEVICE_SECTOR`
if [ "$CHECK_RST" == "" ];then
	mkdir -p /run/media/$DEVICE_NAME
	mount $DEVICE_SECTOR /run/media/$DEVICE_NAME
	echo "SSD mount to /run/media/$DEVICE_NAME OK"
else
	echo SSD already mount
fi

