#安装配置gitlab#
##install##
环境：Ubuntu 14.04  
版本：GitLab CE 最新版本  
URL: https://about.gitlab.com/  
安装指南：https://about.gitlab.com/downloads/#ubuntu1404  

以下摘录官方说明  
1. Install and configure the necessary dependencies

If you install Postfix to send email please select 'Internet Site' during setup. Instead of using Postfix you can also use Sendmail or configure a custom SMTP server. If you wish to use Exim, please configure it as an SMTP server.

On Centos 6 and 7, the commands below will also open HTTP and SSH access in the system firewall.

sudo apt-get install curl openssh-server ca-certificates postfix  
2. Add the GitLab package server and install the package

curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash  
sudo apt-get install gitlab-ce  
If you are not comfortable installing the repository through a piped script, you can find the entire script here.  
Alternatively you can select and download the package manually and install using  
curl -LJO https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/trusty/gitlab-ce-XXX.deb/download  
dpkg -i gitlab-ce-XXX.deb  
3. Configure and start GitLab  

sudo gitlab-ctl reconfigure  
4. Browse to the hostname and login

Username: root   
Password: 5iveL!fe

小插曲：安装用的阿里云，连不上gitlab网站，于是下载了上传手动安装  
##configure##

域名配置  

