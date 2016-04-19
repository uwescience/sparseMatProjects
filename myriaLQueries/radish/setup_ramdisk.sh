#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo "ERROR: must run as root"
	exit
fi

mkdir -p /mnt/ramdisk
mkdir -p $HOME/data

if mount | grep ramdisk > /dev/null; then 
    echo "SKIP: mount /mnt/ramdisk"
else
    echo "mount /mnt/ramdisk"
    mount -t tmpfs -o size=40g tmpfs /mnt/ramdisk
fi

if [ -L $HOME/data ]; then
    echo "SKIP: moving and linking data"   
else
    echo "moving and linking data"   
    su - sgeadmin -c 'mv $HOME/data /mnt/ramdisk/'
    su - sgeadmin -c 'cd $HOME && ln -s /mnt/ramdisk/data'
fi
