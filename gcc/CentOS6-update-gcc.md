```
环境：CentOS 6
描述：编译Aria2需要高版本gcc
gcc：http://ftp.gnu.org/gnu/gcc
```

## 下载解压

## 安装依赖的包
源码目录 contrib/download_prerequisites 脚本会自动安装依赖

## 建立编译目录
mkdir gcc-build

## 编译

进入 gcc-build目录

../gcc-version/configure -enable-checking=release -enable-languages=c,c++ -disable-multilib

make -jxx

make install

## 切换gcc到新版

编译安装一般在 /usr/local/bin 下

upate-alternatives --install gcc-old-path gcc gcc-new-path 40

40为优先级

## 问题
update-alternatives 升级版本没生效？后面用了软连接

lib库也没更新，用了软连接替换了旧的

可以用 strings /usr/local/lib64/libstdc++.so | grep GLIBC 查看

## yum更新
```
#centos 6
yum install centos-release-scl-rh
yum install centos-release-scl
#centos 7
sudo yum install centos-release-scl
#for gcc version 5
sudo yum install devtoolset-4-gcc devtoolset-4-gcc-c++
source /opt/rh/devtoolset-4/enable
```
