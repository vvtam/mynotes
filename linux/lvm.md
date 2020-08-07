# LVM扩容
Ubuntu 16.04 , ESXi 6.5

- 虚拟机关机，在ESXi中修改磁盘大小（或者新建一块虚拟磁盘）
- 重新开机，比如磁盘为sda，sudo fdisk -l /dev/sda 查看磁盘信息
- fdisk /dev/sda 新建一个分区,分区类型(t)为lvm(8e)
- 创建新PV 然后加入VG 然后扩容LVM容量
```
新pv    pvcreate /dev/sda3
扩容vg  vgextend $vg_name /dev/sda3
扩容lv 
lvextend -L +54 /dev/vg01/lvol10 /dev/sdk3
lvextend /dev/vg01/lvol01 /dev/sdk3
lvextend -L+16M vg01/lvol01 /dev/sda:8-9 /dev/sdb:8-9
resize2fs $lvm_root
(xfs_growfs $lvm_root) #用于xfs格式？？？
```

pv  >  vg  >  lv

physical volume  >  volume group  >  logical volume

