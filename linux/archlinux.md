# Arch Linux 安装
## 环境
```
Windows 10 (EFI + GPT)
使用rufus制作的Arch Linux 启动盘
```

可以参考 [官方wiki](https://wiki.archlinux.org/index.php/Installation_guide_(简体中文))

用u盘启动到arch linux   
用fdisk分区   
用mkfs.xx 格式化磁盘   
mount 磁盘到 /mnt(如果有多个分区请分别挂载)   

## 安装系统到磁盘   
pacstrap /mnt base base-devel(如果要编译软件包)   
genfstab -U /mnt >> /mnt/etc/fstab (生成fstab)   
arch-chroot /mnt (到新系统)   

## 初始设置
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
(设置一个时区)   
hwclock --systohc --utc (设为utc 并调整时间)   
```
# vim /etc/locale.gen
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
zh_TW.UTF-8 UTF-8
```
locale-gen (生成locale讯息)   
`echo LANG=en_US.UTF-8 > /etc/locale.conf`
设置系统locale为en_US.UTF-8   
```
设置主机名，hosts
# echo myhostname > /etc/hostname
# vim /etc/hosts
127.0.0.1	localhost.localdomain	localhost
::1		localhost.localdomain	localhost
127.0.1.1	myhostname.localdomain	myhostname
```

## 设置grub启动

1. 安装grub等工具，把efi分区挂载到系统，安装grub
```
# pacman -S dosfstools grub efibootmgr
# mkdir /boot/efi
# mount /dev/sda1 /boot/efi

# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub --recheck
# grub-mkconfig -o /boot/grub/grub.cfg
```
2. 修改grub.cfg增加Windows 启动选项
```
menuentry "Windows 10" {
        insmod part_gpt
        insmod fat
        insmod search_fs_uuid
        insmod chain
        search --fs-uuid --set=root $hints_string $fs_uuid
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
```
其中   
hints_string=grub-probe --target=hints_string /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi

fs_uuid=grub-probe --target=fs_uuid /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi

保存重启
