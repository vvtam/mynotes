## 根据官方wiki最简化安装，efi，grub

### 下载镜像

### 启动镜像，usb，光盘，iso等

### 联网

```
ip link
ip link set ens33 up
ip address add 192.168.159.13/24 dev ens33
ip route add default via 192.168.159.2 dev ens33
```

### 更新时间

```
timedatectl set-ntp true
timedatectl status
```

### 分区磁盘，挂载磁盘

使用fdisk，parted等

测试安装，分了以下几个区，efi使用fat32，其它ext4

```
mkfs.fat -F 32 /dev/efi_system_partition
```

```
# mount /dev/root_partition /mnt
# mount /dev/boot_partition /mnt/boot/
# mount /dev/efi_partition /mnt/boot/efi
```

```
/dev/sda3     /
/dev/sda2     /boot
/dev/sda1     /boot/efi
```

### 安装系统到磁盘

```
pacstrap /mnt base linux linux-firmware
```

### 配置系统

```
genfstab -U /mnt >> /mnt/etc/fstab
```

```
# arch-chroot /mnt
```

```
# ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
```

```
# hwclock --systohc
```

```
# locale-gen
```

```
/etc/locale.conf
LANG=en_US.UTF-8
```

```
# mkinitcpio -P
```

```
# passwd
```

### Boot loader

```
pacman -Syu grub efibootmgr

grub-install --target=x86_64-efi --efi-directory=/boot/efi/ --bootloader-id=GRUB --removable --recheck
grub-mkconfig -o /boot/grub/grub.cfg
```

### 重启

### 安装完后配置

#### 网络

ip link
ip link set ens33 up
ip address add 192.168.159.13/24 dev ens33
ip route add default via 192.168.159.2 dev ens33

添加网络配置

nvim /etc/systemd/network/20-wired-ens33.network

systemctl enable systemd-networkd.service

dns配置/etc/resolv.conf，或者使用resovle服务

#### 安装openssh

pacman -Syu openssh

### 问题总结

#### 安装了oh-my-zsh tab 补全的问题

```
去掉 /etc/locale.gen中
en_US.UTF-8 UTF-8的注释‘#’
运行
locale-gen
```

