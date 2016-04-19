#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo "ERROR: must run as root"
	exit
fi

mkdir -p /mnt/ramdisk

if mount | grep ramdisk > /dev/null; then 
    echo "SKIP: mount /mnt/ramdisk"
else
    echo "mount /mnt/ramdisk"
    mount -t tmpfs -o size=40g tmpfs /mnt/ramdisk
fi

if [ -L /mnt/ramdisk/data ]; then
    echo "cleaned up bad symlink /mnt/ramdisk/data"
    rm /mnt/ramdisk/data
fi

if [ -L ~sgeadmin/data ]; then 
    echo "~sgeadmin/data exists, please remove if it is broken" 
    exit
fi
   
if [ -d /mnt/ramdisk/data ]; then
    echo "/mnt/ramdisk/data exists, so not moving anything"
else
    su - sgeadmin -c 'mkdir -p $HOME/data'
    echo "moving and linking data"   
    su - sgeadmin -c 'mv $HOME/data /mnt/ramdisk/'
fi

if [ -d ~sgeadmin/data ]; then
    echo "~sgeadmin/data not pointed to /mnt/ramdisk/data; please determine which is golden copy and delete the other"
    exit
else
    su - sgeadmin -c 'cd $HOME && ln -s /mnt/ramdisk/data'
fi
