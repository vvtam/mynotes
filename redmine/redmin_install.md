#redmine 安装#
**请使用普通用户，不要用root，根据提示用sudo即可**

```
环境：
Ubuntu 14.04
nginx 使用passenger带的脚本来安装，或者自己编译（要编译passenger支持）
mysql
ruby rails
```

1. 新增源
```添加key和证书
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7  
sudo apt-get install apt-transport-https ca-certificates  
```
