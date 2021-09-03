#!/bin/bash
#--------------------------------------------------------
# pxe启动，实用于bios和uefi启动
# t.vv@msn.com
# 20210625
#--------------------------------------------------------
dhcp_subnet='192.168.159.0'
dhcp_netmask='255.255.255.0'
dhcp_range='192.168.159.200 192.168.159.250'
dhcp_server='192.168.159.11'
dhcp_route='192.168.159.11'
http_server='192.168.159.11'
## 挂载的目录，http也使用这个目录
mount_point='/var/www/html/cdrom'
iso_file='/root/CentOS-7-x86_64-DVD-2009.iso'
syslinux_version='syslinux-4.05-15.el7.x86_64.rpm'
shim_version='shim-x64-15-8.el7.x86_64.rpm'
grub2_efi_version='grub2-efi-x64-2.02-0.86.el7.centos.x86_64.rpm'

yum install -y dhcp xinetd tftp-server httpd
## 在 /etc/xinet.d/tftp 配置文件中，将 disabled 参数从 yes 改为 no #

# DHCP配置文件
cat >>dhcpd.conf<<EOFdhcp
option space pxelinux;
option pxelinux.magic code 208 = string;
option pxelinux.configfile code 209 = text;
option pxelinux.pathprefix code 210 = text;
option pxelinux.reboottime code 211 = unsigned integer 32;
option architecture-type code 93 = unsigned integer 16;

subnet ${dhcp_subnet} netmask ${dhcp_netmask} {
  option routers ${dhcp_route};
  range ${dhcp_range};
  #option subnet-mask ${dhcp_netmask};
  #default-lease-time 21600;
  #max-lease-time 43200;
  class "pxeclients" {
    match if substring (option vendor-class-identifier, 0, 9) = "PXEClient";
    next-server ${dhcp_server};

    if option architecture-type = 00:07 {
      filename "uefi/shim.efi";
    } else {
      filename "pxelinux/pxelinux.0";
    }
  }
}
EOFdhcp

cp dhcpd.conf /etc/dhcp/dhcpd.conf

# 挂载ISO，准备pxe，tftp的文件
mkdir -p ${mount_point}
mount -t iso9660 ${iso_file} ${mount_point} -o loop,ro
#umount /mount_point

# 准备bios启动文件
cp -pr ${mount_point}/Packages/${syslinux_version} .
rpm2cpio ${syslinux_version} | cpio -dimv

mkdir /var/lib/tftpboot/pxelinux
cp ./usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/pxelinux

mkdir /var/lib/tftpboot/pxelinux/pxelinux.cfg
cat >>/var/lib/tftpboot/pxelinux/pxelinux.cfg/default<<EOFbios
default vesamenu.c32
## 要手动按enter?
# prompt 1
## 600是60s
timeout 600

display boot.msg

label linux
  menu label ^Install system
  menu default
  kernel vmlinuz
  append initrd=initrd.img ip=dhcp inst.repo=http://${http_server}/cdrom inst.ks=http://${http_server}/ks.cfg
  # append initrd=initrd.img ip=dhcp inst.repo=http://${http_server}/cdrom inst.ks=http://${http_server}/ks.cfg quiet
label vesa
  menu label Install system with ^basic video driver
  kernel vmlinuz
  append initrd=initrd.img ip=dhcp inst.xdriver=vesa nomodeset inst.repo=http://${http_server}/cdrom inst.ks=http://${http_server}/ks.cfg quiet
label rescue
  menu label ^Rescue installed system
  kernel vmlinuz
  append initrd=initrd.img rescue
label local
  menu label Boot from ^local drive
  localboot 0xffff
EOFbios
cp ${mount_point}/isolinux/{boot.msg,vesamenu.c32,vmlinuz,initrd.img} /var/lib/tftpboot/pxelinux/

## 准备UEFI启动文件
# mount -t iso9660 /path_to_image/name_of_image.iso /mount_point -o loop,ro
cp -pr ${mount_point}/Packages/${shim_version} .
cp -pr ${mount_point}/Packages/${grub2_efi_version} .
rpm2cpio ${shim_version} | cpio -dimv
rpm2cpio ${grub2_efi_version} | cpio -dimv
 
mkdir /var/lib/tftpboot/uefi
cp ./boot/efi/EFI/centos/shim.efi /var/lib/tftpboot/uefi/
cp ./boot/efi/EFI/centos/grubx64.efi /var/lib/tftpboot/uefi/
cat >>/var/lib/tftpboot/uefi/grub.cfg<<EOFuefi
## 10s
set timeout=10
  menuentry 'Install system' {
  linuxefi uefi/vmlinuz ip=dhcp inst.repo=http://${http_server}/cdrom inst.ks=http://${http_server}/ks.cfg
  #linuxefi uefi/vmlinuz ip=dhcp inst.repo=http://${http_server}/cdrom inst.ks=http://${http_server}/ks.cfg quiet
  initrdefi uefi/initrd.img
}
EOFuefi
cp ${mount_point}/images/pxeboot/{vmlinuz,initrd.img} /var/lib/tftpboot/uefi/

# kickstart文件
cat >>/var/www/html/ks.cfg<<EOFks
#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Use CDROM installation media
url --url="http://${http_server}/cdrom"
# Use graphical install
#graphical
text
# Run the Setup Agent on first boot
firstboot --enabled
# 指定要使用的磁盘
ignoredisk --only-use=sda
reboot
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8 --addsupport=zh_CN.UTF-8

# Network information
# network  --bootproto=static --device=ens33 --gateway=192.168.159.2 --ip=192.168.159.11 --nameserver=223.5.5.5 --netmask=255.255.255.0 --ipv6=auto --activate
# network  --hostname=centos7

# Root password
rootpw --lock
# System services
services --enabled="chronyd"
# System timezone
timezone Asia/Shanghai --isUtc
user --groups=wheel --name=ops --password=$6$x0lKWPA1rj9vW04D$mCvRnj.nloQ/NLdIOyiiYIhcvcTrlKPqW5ATZdliIt9e.EzTowzcJGzujyv5VdJMGHo0vornZCAbKGKwX7Z9E1 --iscrypted --gecos="ops"
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr
autopart --type=lvm
# Partition clearing information
clearpart --all --initlabel

%packages
@^minimal
@core
chrony
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
EOFks

## start
systemctl enable --now dhcpd.service
systemctl enable --now tftp
systemctl enable --now xinetd
systemctl enable --now httpd
## restart
systemctl enable --now dhcpd.service
systemctl enable --now tftp
systemctl enable --now xinetd
systemctl enable --now httpd
## open the firewall
firewall-cmd --add-service=tftp --permanent
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=dhcp --permanent
