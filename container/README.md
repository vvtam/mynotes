# 安装配置环境

## What is a container

### unshare can launch "contained" processes

````
sudo unshare --fork --pid --mount-proc bash
ps
exit
````

### nsenter used to attach processed to existing namespaces for debug

`nsenter --target exist_pid --mount --uts --ipc --net --pid ps aux`

with docker, the net namespace will be shared

`docker run -d --name=web --net=container:db nginx:alpine`

```
$ ls -lha /proc/$WEBPID/ns/ | grep net
net -> net:[4026532160]
$ ls -lha /proc/$DBPID/ns/ | grep net
net -> net:[4026532160]
```

### chroot

Chroot provides the ability for a process to start with a different root directory to the parent OS. This allows different files to appear in the root.

### cgroups(control groups)

CGroups limit the amount of resources a process can consume. These cgroups are values defined in particular files within the /proc directory.

`cat /proc/$DBPID/cgroup` mapped to `/sys/fs/cgroup/`

The CPU stats and usage is stored within a file too!

```
cat /sys/fs/cgroup/cpu,cpuacct/docker/$DBID/cpuacct.stat
```

The CPU shares limit is also defined here.

```
cat /sys/fs/cgroup/cpu,cpuacct/docker/$DBID/cpu.shares
```

All the Docker cgroups for the container's memory configuration are stored within:

```
ls /sys/fs/cgroup/memory/docker/
```

### how to configure cgroups

`docker stats db --no-stream`

The memory quotes are stored in a file called `memory.limit_in_bytes`.

By writing to the file, we can change the limit limits of a process.

`echo 8000000 > /sys/fs/cgroup/memory/docker/$DBID/memory.limit_in_bytes`

### Seccomp, AppArmor

All actions with Linux is done via syscalls. The kernel has 330 system calls that perform operations such as read files, close handles and check access rights. All applications use a combination of these system calls to perform the required operations.

AppArmor is a application defined profile that describes which parts of the system a process can access.

It's possible to view the current AppArmor profile assigned to a process via `cat /proc/$DBPID/attr/current`

The default AppArmor profile for Docker is `docker-default (enforce)`.

Prior to Docker 1.13, it stored the AppArmor Profile in /etc/apparmor.d/docker-default (which was overwritten when Docker started, so users couldn't modify it. After v1.13, Docker now generates docker-default in tmpfs, uses apparmor_parser to load it into kernel, then deletes the file

The template can be found at https://github.com/moby/moby/blob/a575b0b1384b2ba89b79cbd7e770fbeb616758b3/profiles/apparmor/template.go

Seccomp provides the ability to limit which system calls can be made, blocking aspects such as installing Kernel Modules or changing the file permissions.

The default allowed calls with Docker can be found at https://github.com/moby/moby/blob/a575b0b1384b2ba89b79cbd7e770fbeb616758b3/profiles/seccomp/default.json

When assigned to a process it means the process will be limited to a subset of the ability system calls. If it attempts to call a blocked system call is will recieve the error "Operation Not Allowed".

The status of SecComp is also defined within a file.

```
cat /proc/$DBPID/status
cat /proc/$DBPID/status | grep Seccomp
```

The flag meaning are: 0: disabled 1: strict 2: filtering

### Capabilities

Capabilities are groupings about what a process or user has permission to do. These Capabilities might cover multiple system calls or actions, such as changing the system time or hostname.

The status file also containers the Capabilities flag. A process can drop as many Capabilities as possible to ensure it's secure.

```
cat /proc/$DBPID/status | grep ^Cap
```

The flags are stored as a bitmask that can be decoded with `capsh`

```
capsh --decode=00000000a80425fb
```

### Container Image

A container image is a tar file containing tar files. Each of the tar file is a layer. Once all tar files have been extract into the same location then you have the container's filesystem.

This can be explored via Docker. Pull the layers onto your local system.

```
docker pull redis:3.2.11-alpine
```

Export the image into the raw tar format.

```
docker save redis:3.2.11-alpine > redis.tar
```

Extract to the disk

```
tar -xvf redis.tar
```

All of the layer tar files are now viewable.

```
ls
```

The image also includes metadata about the image, such as version information and tag names.

```
cat repositories
cat manifest.json
```

Extracting a layer will show you which files that layer provides.

```
tar -xvf da2a73e79c2ccb87834d7ce3e43d274a750177fe6527ea3f8492d08d3bb0123c/layer.tar
```

### Creating Empty Image

As an image is just a tar file, an empty image can be created using the command below.

```
tar cv --files-from /dev/null | docker import - empty
```

By importing the tar, the additional metadata will be created.

```
docker images
```

However, as the container doesn't contain anything, it can't start a process.

##  Getting container tools

```
# redhat
# subscription-manager register
Registering to: subscription.rhsm.redhat.com:443/subscription
Username: ********
Password: **********

subscription-manager attach --auto

yum module install -y container-tools
# Install podman-docker (optional)
yum install -y podman-docker
```

## Running containers as root or rootless

```
# yum install slirp4netns podman -y
# echo "user.max_user_namespaces=28633" > /etc/sysctl.d/userns.conf
# sysctl -p /etc/sysctl.d/userns.conf
# useradd -c "Joe Jones" joe
# passwd joe
# su -l joe
$ podman pull registry.access.redhat.com/ubi8/ubi
$ podman run registry.access.redhat.com/ubi8/ubi cat /etc/os-release
NAME="Red Hat Enterprise Linux"
VERSION="8.1 (Ootpa)"
...

$ podman unshare cat /proc/self/uid_map
         0       1001       1
         1      65537   65536
```

### Upgrade to rootless containers

**If you have upgraded from RHEL 7, you must configure subuid and subgid values manually for any existing user you want to be able to use rootless podman.**

[rootless](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/starting-with-containers_building-running-and-managing-containers#set_up_for_rootless_containers)



# podman

## podman pull

`podman pull daocloud.io/library/nginx`

## podman Dockerfile

```
FROM daocloud.io/library/centos

RUN echo 'hello'
```

## podman run

```
podman images
podman run -p 8080:80 REPOSITORY/IMAGE ID
```

## podman stop

```
podman stop CONTAINER ID
```

## podman systemd

```
[Unit]
Description=Custom MariaDB Podman Container
After=network.target

[Service]
Type=simple
TimeoutStartSec=5m
ExecStartPre=-/usr/bin/podman rm "mariadbpodman"

ExecStart=/usr/bin/podman run --name mariadbpodman -v /root/mysql-data:/var/lib/mysql/data:Z -e MYSQL_USER=user -e MYSQL_PASSWORD=pass -e MYSQL_DATABASE=db -p 3306:3306 registry.access.redhat.com/rhscl/mariadb-102-rhel7

ExecReload=-/usr/bin/podman stop "mariadbpodman"
ExecReload=-/usr/bin/podman rm "mariadbpodman"
ExecStop=-/usr/bin/podman stop "mariadbpodman"
Restart=always
RestartSec=30
```

## rootless

从root切换到其它用户的时候要su -l user，不然会提示

```
Error: could not get runtime: error generating default config from memory: cannot mkdir /run/user/0/libpod: mkdir /run/user/0/libpod: permission denied
```

## podman save

保存image到本地

## podman load

导入本地image



# buildah



## Dockerfile构建

buildah build-using-dockerfile -t name .

```
FROM registry.redhat.io/ubi8/ubi
ADD myecho /usr/local/bin
ENTRYPOINT "/usr/local/bin/myecho"
```



## Modifying a container to create a new image with Buildah

```
buildah from daocloud.io/library/centos
buildah run centos-working-container yum install httpd -y
buildah copy centos-working-container index.html /var/www/html/index.html
buildah config --entrypoint "/usr/sbin/httpd -DFOREGROUND" centos-working-container #给容器配置 entrypoint，等同于 Dockerfile 中的 ENTRYPOINT
buildah commit centos-working-container centos-httpd
podman run --name httpd -p 8081:80 centos-httpd #将该容器制作为镜像，保存在 /var/lib/containers/
```

###  buildah mount

```
[root@centos8 hello]# buildah from localhost/centos-httpd
centos-httpd-working-container
[root@centos8 hello]# buildah mount centos-httpd-working-container
/var/lib/containers/storage/overlay/d48883bd1e4b06abab51c19bd823c82ddf6635f66076cb5639ab8a3d08ae5451/merged

vim /var/lib/containers/storage/overlay/d48883bd1e4b06abab51c19bd823c82ddf6635f66076cb5639ab8a3d08ae5451/merged/var/www/html/index.html

buildah commit centos-httpd-working-container centos-httpd

```

## Creating images from scratch with Buildah

```
# buildah from scratch
working-container
# scratchmnt=$(buildah mount working-container)
# echo $scratchmnt
/var/lib/containers/storage/overlay/38bb43622da3f1a33cfbc8606b7769af54bfe87536d835331283a9234b079ac6/merged

# yum install -y --releasever=8 --installroot=$scratchmnt centos-release
# yum install -y --setopt=reposdir=/etc/yum.repos.d \
     --installroot=$scratchmnt \
     --setopt=cachedir=/var/cache/dnf httpd
     
# echo "Your httpd container from scratch worked." > $scratchmnt/var/www/html/index.html

# buildah config --cmd "/usr/sbin/httpd -DFOREGROUND" working-container
# buildah config --port 80/tcp working-container
# buildah commit working-container localhost/myhttpd:latest

# podman images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
localhost/myhttpd   latest              47c0795d7b0e        9 minutes ago       665.6 MB
# podman run -p 8080:80 -d --name httpd-server 47c0795d7b0e
# curl localhost:8080
Your httpd container from scratch worked.
```



```
#!/usr/bin/env bash 

# https://zdyxry.github.io/2019/10/19/Buildah-初次体验/

set -o errexit

# Create a container
container=$(buildah from fedora:28)
mountpoint=$(buildah mount $container)

buildah config --label maintainer="yiran <zdyxry@gmail.com>" $container

curl -sSL http://ftpmirror.gnu.org/hello/hello-2.10.tar.gz \
     -o /tmp/hello-2.10.tar.gz
tar xvzf src/hello-2.10.tar.gz -C ${mountpoint}/opt

pushd ${mountpoint}/opt/hello-2.10
./configure
make
make install DESTDIR=${mountpoint}
popd

chroot $mountpoint bash -c "/usr/local/bin/hello -v"

buildah config --entrypoint "/usr/local/bin/hello" $container
buildah commit --format docker $container hello
buildah unmount $container
```

