## fdisk
先删除 d  
在新建 n  

保存  

卸载 umount 分区  
e2fsck -f /dev/xx 检查分区  
e2fsck -f /dev/xx 扩容分区  #xfs_growfs /dev/xx xfs  

挂载  
mount  

## parted 分区
