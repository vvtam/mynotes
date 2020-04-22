# yum创建离线repo
## 有网络机器-最好最小化安装
比如下载ansible和依赖包  
```
yum install yum-utils
yumdownloader --resolve --destdir /root/ansible-packages ansible
yumdownloader --resolve --destdir /root/ansible-packages createrepo
```
## 目标机器  
`createrepo /root/ansible-packages`

/etc/yum.repos.d/local-ansible.repo
```
[local-ansible]
name=CentOS-$releasever - Media
baseurl=file:///root/ansible-packages
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```
## 安装
```
yum clean all
yum update
yum install ansible
```