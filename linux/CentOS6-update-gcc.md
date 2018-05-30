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

