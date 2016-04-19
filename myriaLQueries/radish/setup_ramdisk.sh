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
    echo "removing symlink ~sgeadmin/data"
    rm ~sgeadmin/data
fi
    
su - sgeadmin -c 'mkdir -p $HOME/data'

if [ -d ~sgeadmin/data ]; then
    echo "moving and linking data"   
    su - sgeadmin -c 'mv $HOME/data /mnt/ramdisk/'
    su - sgeadmin -c 'cd $HOME && ln -s /mnt/ramdisk/data'
else
    echo "ERROR: ~sgeadmin/data should be a directory"
fi
