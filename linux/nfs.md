## nfs

mount 手动挂载

/etc/fstab 启动是挂载

autofs 或者 systemd.automount 按需挂载

nfsv4 仅使用tcp，较早版本可使用tcp和udp

[root@vm213 ~]# cat /etc/nfs.conf

```
...
#
[nfsd]
# debug=0
# threads=8
# host=
# port=0
# grace-time=90
# lease-time=90
# tcp=y
# vers2=n
# vers3=y
# vers4=y
# vers4.0=y
# vers4.1=y
# vers4.2=y
# rdma=n
# rdma-port=20049
#
...
```

nfsconf --set nfsd vers4.2 y #会更新/etc/nfs.conf中nfsd段落中的vers4.2为y

nfsconf --get nfsd vers4.2

nfsconf --unset nfsd vers4.2



## autofs

yum -y install autofs

systemctl enable --now autofs.service

### 间接映射

vim /etc/auto.master.d/demo.autofs

```
/shares  /etc/auto.demo   #share目录是自动挂载的基础目录
```

/etc/auto.demo

```
work  -rw,sync       serverb:/shares/work   #挂载点是 /shares/work
```

### 直接映射

vim /etc/auto.master.d/demo.autofs

```
/- /etc/auto.direct
```

/etc/auto.direct

```
/mnt/docs -rw,sync   serverb:/shares/docs
```

### 间接通配符映射

vim /etc/auto.master.d/demo.autofs

```
/shares  /etc/auto.demo   #share目录是自动挂载的基础目录
```

/etc/auto.demo

```
*  -rw,sync       serverb:/shares/& 
```

### 