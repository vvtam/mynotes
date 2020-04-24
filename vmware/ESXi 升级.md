# ESXi 升级

## 登录VMware官网下载最新的升级包

官网地址：[https://my.vmware.com](https://my.vmware.com/)

需要你自己注册一个账号密码

## 上传到数据区，开启ssh，登录

![img](pic/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_15877064428763.png)

## 登录ssh获取相关信息  

esxcli software sources profile list -d /vmfs/volumes/5a4bc461-22a5d0d4-4418-1418776fe650/isoss/ESXi670-202004001.zip  

![img](pic/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_15877065797369.png)

## 升级

esxcli software profile update -d /vmfs/volumes/5a4bc461-22a5d0d4-4418-1418776fe650/isoss/ESXi670-202004001.zip -p ESXi-6.7.0-20200403001-standard



reboot 重启