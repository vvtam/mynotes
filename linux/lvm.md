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
lvextend -L +300M /dev/vg01/lv01  #-L，-l
lvextend /dev/vg01/lvol01 /dev/sdk3
lvextend -l +50%FREE /dev/vg01/lv01 #添加当前可用空间的50%
lvextend -L +16M vg01/lv01 /dev/sda:8-9 /dev/sdb:8-9
resize2fs $lvm_root #ext4，采用逻辑卷名称
xfs_growfs $lvm_root #xfs格式，采用挂载点，或者lvextend -r 选项

缩减卷组
pvmove /dev/vdb3 #移动/dev/vdb3上的PE到同一VG具有空闲PE的pv上，备份，如果意外断电，数据丢失
vgreduce vg01 /dev/vdb3 #从vg01 VG中删除 /dev/vdb3，或者使用pvremove永久删除PV

交换空间需要停用才能扩容
```

pv  >  vg  >  lv

pe <--------> le   物理区块-逻辑区块

physical volume  >  volume group  >  logical volume

## parted 准备lvm物理设备

parted -s /dev/sdb mkpart primary 1MiB 999MiB

parted -s /dev/sdb mkpart primary 1000MiB 1999MiB

parted -s /dev/sdb set 1 lvm on

parted -s /dev/sdb set 2 lvm on

## 创建pv vg lv

创建pv

pvcreate /dev/sdb1 /dev/sdb2

创建vg

vgcreate vgname /dev/sdb1 /dev/sdb2

创建lv

lvcreate -n lvname -L 700M vgname #vgname中创建一个700MiB的lv，-l指定区块，-L 指定大小

用名称挂载逻辑卷等同于用uuid挂载