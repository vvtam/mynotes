## 从centos官方镜像修改自己的镜像

下载地址

`https://cloud.centos.org/altarch/7/images/CentOS-7-x86_64-GenericCloud.qcow2`

### 修改信息后启动

建临时目录
```
mkdir tmp
cd tmp

```

创建一个名为 `meta-data` 的文件。在该文件中添加以下信息。

   ```none
   instance-id: citest
   local-hostname: citest-1
   ```

创建名为 `user-data` 的文件。在该文件中包含以下信息。

   ```none
   #cloud-config
   password: cilogon
   chpasswd: {expire: False}
   ssh_pwauth: True
   ssh_authorized_keys:
     - ssh-rsa AAA...fhHQ== sample@redhat.com
   ```



使用 `genisoimage` 命令创建包含 `user-data` 和 `meta-data` 的 ISO 镜像 。

```none
# genisoimage -output ciiso.iso -volid cidata -joliet -rock user-data meta-data

I: -input-charset not specified, using utf-8 (detected in locale settings)
Total translation table size: 0
Total rockridge attributes bytes: 331
Total directory bytes: 0
Path table size(bytes): 10
Max brk space used 0
183 extents written (0 MB)
```

下载 KVM 客户机镜像，并把它放到 `/var/lib/libvirt/images` 目录中。

使用 `virt-install` 命令从 KVM 客户机镜像创建新虚拟机。包含您创建的 ISO 镜像作为镜像的附件。

```none
virt-install \
    --memory 4096 \
    --vcpus 4 \
    --name mytestcivm \
    --disk /var/lib/libvirt/images/CentOS-7-x86_64-GenericCloud.qcow2,device=disk,bus=virtio,format=qcow2 \
    --disk tmp/ciiso.iso,device=cdrom \
    --os-type Linux \
    --virt-type kvm \
    --graphics none \
    --import
```

登录到您的镜像 `cloud-user`。您的密码是 `cilogon`。

```none
citest-1 login: cloud-user
Password:
[cloud-user@citest-1 ~]$
```

### 导出xml

virsh dumpxml vm-name > vm-name.xml

### 复用

修改vm-name.xml  配合 CentOS-7-x86_64-GenericCloud.qcow2 可快速部署虚拟机

### 常用命令

```
virsh list -all
virsh console vm-name
virsh shutdown vm-name
virsh undefine vm-name

virsh dumpxml centos7 > centos7.xml
virsh define /home/vms/znyy/znyy.xml
# Escape character is ^]
```

## 自己制作qcow2镜像

```
virt-install \
--virt-type=kvm \
--name=centos7 \
--vcpus=2 \
--memory=4096 \
--location=CentOS-7-x86_64-Minimal-2009.iso \
--disk path=./tmp/centos7.qcow2,size=100,format=qcow2 \
--network bridge=virbr0 \
--graphics none \
--extra-args='console=ttyS0' \
--force
```

```
复制镜像文件到其他目录cp ./tmp/centos7.qcow2 centos7.qcow2

导出压缩后的镜像文件qemu-img convert -c -O qcow2 centos7.qcow2 new-centos7.qcow2
```

### qcow2 格式的压缩

首先，需要对虚拟机系统对剩余空间写零操作：

```
$ dd if=/dev/zero of=/zero.dat
```

删除 zero.dat：

```
$ rm /zero.dat
```

关闭虚拟机，进入虚拟机镜像文件的目录，通过 qemu-img 的 convert 来操作：

```
$ qemu-img convert -c -O qcow2 /path/old.img.qcow2 /path/new.img.qcow2
```

### raw 格式的压缩。

附带说一下 raw 格式的压缩。
也是先进虚拟机系统对剩余空间写零操作，随后删除 zero.dat，关闭虚拟机。最后通过 cp 的稀疏复制，把零全部释放

```
$ cp --sparse=always /path/old.raw /path/new.raw
```

raw 镜像比 qcow2 镜像速度略快，但是 qcow2 镜像有增量功能，一般情况下，我们都采用 qcow2 镜像格式，
qemu-img 的 convert 也能转化 raw 成 qcow2：

```
$ qemu-img convert -c -f raw -O qcow2 /path/old.raw /path/new.qcow2
```
