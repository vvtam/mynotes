# 安装配置环境

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

## 容器构建镜像

```
buildah from daocloud.io/library/centos
buildah run centos-working-container yum install httpd -y
buildah copy centos-working-container index.html /var/www/html/index.html
buildah config --entrypoint "/usr/sbin/httpd -DFOREGROUND" centos-working-container #给容器配置 entrypoint，等同于 Dockerfile 中的 ENTRYPOINT
buildah commit centos-working-container centos-httpd
podman run --name httpd -p 8081:80 centos-httpd #将该容器制作为镜像，保存在 /var/lib/containers/
```

## buildah mount

```
[root@centos8 hello]# buildah from localhost/centos-httpd
centos-httpd-working-container
[root@centos8 hello]# buildah mount centos-httpd-working-container
/var/lib/containers/storage/overlay/d48883bd1e4b06abab51c19bd823c82ddf6635f66076cb5639ab8a3d08ae5451/merged

vim /var/lib/containers/storage/overlay/d48883bd1e4b06abab51c19bd823c82ddf6635f66076cb5639ab8a3d08ae5451/merged/var/www/html/index.html

buildah commit centos-httpd-working-container centos-httpd

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

