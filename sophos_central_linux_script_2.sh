# On kernels that have limitations for on-access scanning, using yum package manager:
#! /bin/bash 
yum update -y
yum install gcc kernel-headers kernel-devel -y
wget <LinkToInstaller> -P /tmp/
chmod +x /tmp/SophosInstall.sh
/tmp/SophosInstall.sh