#编译用于linksys ea3500 openwrt 的ipk#

参考 https://github.com/softwaredownload/openwrt-fanqiang/blob/master/ebook/04.1.md  

##前面的坑##

用 https://downloads.openwrt.org/snapshots/trunk/kirkwood/generic/ 这里下载的tunk版本刷机成功  
用 相同的sdk编译ipk成功 https://downloads.openwrt.org/snapshots/trunk/kirkwood/generic/OpenWrt-SDK-kirkwood_gcc-5.3.0_musl-1.1.16_eabi.Linux-x86_64.tar.bz2  

ssh 到路由器安装ipk包成功，但是运行命令提示不存在，结果就是不兼容  

##从openwrt源码来编译##

- 安装依赖库  
`sudo apt-get install build-essential subversion libncurses5-dev zlib1g-dev gawk gcc-multilib flex git-core gettext`

- 下载源码  
`git clone git://git.openwrt.org/openwrt.git`

- 更新feed，根据路由器型号设置target  
```
cd yourdownlaoddir/openwrt
./scripts/feeds update -a
./scripts/feeds install -a  
# run make menuconfig and set target; 
# 每个版本设置路径不一样
# Choose your own Target System -> SubTarget -> Target Profile
make menuconfig
make defconfig
```
- 编译相关工具和库  
`make prereq && make tools/install && make toolchain/install`

时间较长

- 编译自己的包  

比如  
git clone https://github.com/aa65535/openwrt-dns-forwarder.git package/dns-forwarder  

`make menuconfig`
到network选择dns-forwarder，编译成模块，也就是单独的ipk安装文件  

保存，退出 

`make package/dns-forwarder/compile V=99`

编译完成后在bin目录下

待续
