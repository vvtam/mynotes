## Stratis卷管理文件系统

设备映射器 dm

逻辑卷管理器 lvm

xfs 文件系统

使用Backstore子系统管理块设备

使用Thinpool子系统管理池

Backstore数据层维护磁盘上元数据，检测纠正数据损坏，缓存层使用高性能块设备作为数据层之上的缓存

dm-thin

yum -y install stratis-cli stratisd

systemctl enable --now stratisd #激活服务

stratis pool create pool1 /dev/vdb #创建池

stratis pool list #查看可用池

stratis pool add-data pool1 /dev/vdc #添加块设备

stratis blockdev list pool1 #查看pool1池的块设备

stratis  filesystem create pool1 filesystem1 # 创建文件系统

stratis  filesystem snapshot pool1 filesystem1 snapshot1 # 创建快照

stratis  filesystem list #查看可用文件系统

lsblk --output=UUID /stratis/pool1/filesystem1 #显示uuid以便挂载

uuid=XXX   /DIR1 xfs default,x-systemd.requires=stratisd.service 0 0 #挂载选项需要stratisd.service

```
[root@vm213 ~]# stratis pool create pool1 /dev/sdb
[root@vm213 ~]# stratis pool list 
Name                    Total Physical
pool1  100 GiB / 45.66 MiB / 99.96 GiB
stratis pool add-data pool1 /dev/sdc
[root@vm213 ~]# stratis blockdev list
Pool Name  Device Node  Physical Size  Tier
pool1      /dev/sdb           100 GiB  Data
pool1      /dev/sdc           100 GiB  Data
[root@vm213 ~]# stratis filesystem create pool1 filesystem1
[root@vm213 ~]# stratis filesystem snapshot pool1 filesystem1 snapshot1
[root@vm213 ~]# stratis filesystem list
Pool Name  Name         Used     Created            Device                      UUID                            
pool1      filesystem1  546 MiB  Sep 03 2020 09:37  /stratis/pool1/filesystem1  972da7f599c34f678ac17504bc353c8d
pool1      snapshot1    546 MiB  Sep 03 2020 09:41  /stratis/pool1/snapshot1    34d6c45152ee48239c72ff5d44467ec0

[root@vm213 ~]# lsblk --output=uuid /stratis/pool1/filesystem1
UUID
972da7f5-99c3-4f67-8ac1-7504bc353c8d

[root@vm213 pool1fs1]# cat /etc/fstab 

#
# /etc/fstab
# Created by anaconda on Fri Aug 21 03:52:25 2020
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rhel_vm213-root /                       xfs     defaults        0 0
UUID=9b5aab40-31fa-418f-be33-ae7ea587dec7 /boot                   xfs     defaults        0 0
UUID=D34B-5F2E          /boot/efi               vfat    umask=0077,shortname=winnt 0 2
/dev/mapper/rhel_vm213-home /home                   xfs     defaults        0 0
/dev/mapper/rhel_vm213-swap swap                    swap    defaults        0 0
UUID=972da7f5-99c3-4f67-8ac1-7504bc353c8d  /mnt/pool1fs1 xfs defaults,x-systemd.requires=stratisd.service 0 0

systemctl daemon-reload
mount -a

stratis filesystem destroy pool1 filesystem1
stratis filesystem destroy pool1 snapshot1
stratis pool destroy pool1
```

## VDO虚拟数据优化器

yum install vdo kmod-kvdo

```
[root@vm213 ~]# vdo create --name=vdo1 --device=/dev/sdb --vdoLogicalSize=50G
Creating VDO vdo1
      The VDO volume can address 96 GB in 48 data slabs, each 2 GB.
      It can grow to address at most 16 TB of physical storage in 8192 slabs.
      If a larger maximum size might be needed, use bigger slabs.
Starting VDO vdo1
Starting compression on VDO vdo1
VDO instance 0 volume is ready at /dev/mapper/vdo1

[root@vm213 ~]# vdo status --name=vdo1
VDO status:
  Date: '2020-09-03 10:52:32+08:00'
  Node: vm213.rhel8
Kernel module:
  Loaded: true
  Name: kvdo
  Version information:
    kvdo version: 6.2.2.117
Configuration:
  File: /etc/vdoconf.yml
  Last modified: '2020-09-03 10:51:04'
VDOs:
  vdo1:
...
启动停止vdo卷，vdo卷可以加入lvm物理卷
vdo stop --name vdo1
vdo start --name vdo1

[root@vm213 ~]# vdo status --name vdo1 | grep Deduplication
    Deduplication: enabled
    
[root@vm213 ~]# vdo status --name vdo1 | grep Compression
    Compression: enabled
    
[root@vm213 vdo1]# vdostats --human-readable 
Device                    Size      Used Available Use% Space saving%
/dev/mapper/vdo1        100.0G      4.1G     95.9G   4%           99%
```

