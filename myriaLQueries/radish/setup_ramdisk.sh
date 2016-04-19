#!/bin/bash

if [ `whoami` != 'root' ]; then
	echo "ERROR: must run as root"
	exit
fi

mkdir /mnt/ramdisk
mount -t tmpfs -o size=40g tmpfs /mnt/ramdisk
su - sgeadmin -c 'ln -s /mnt/ramdisk $HOME/ramdisk'
su - sgeadmin -c 'mv $HOME/data $HOME/ramdisk'
su - sgeadmin -c 'cd $HOME && ln -s ramdisk/data'
