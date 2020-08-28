## sudo su -

该命令完全向正常登录设置root环境

visudo 编辑 /etc/sudoers

%group  ALL=(ALL)            ALL   # %表示组

user        ALL=(ALL)            ALL   #

user        ALL=(ALL)            NOPASSWD:ALL   #不用输入密码

## sudo -i

该命令在配置上和正常登录有细微的差别，比如设置的PATH变量略有不通，会影响shell查找命令的位置

可以设置让sudo -i和su - 更为相识

Defaults              secure_path = /usr/local/bin:/usr/bin

Defaults>root    secure_path = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

## sudo -s

## su

## su - -l --login