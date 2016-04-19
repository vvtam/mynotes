#firewall的基本使用#
firewall-cmd --get-zones 获取zones  
firewall-cmd --get-default-zone 获取当前默认zone  
firewall-cmd --get-services  获取当前支持的services，但是不一定启用  
firewall-cmd --list-services 获取已经启用的services   
systemctl reload firewalld  重新载入配置  
firewall-cmd --add-service=modssh  添加modssh services  
firewall-cmd --remove-service=ssh  删除ssh services  

系统自带的zones和services的目录是  
/usr/lib/firewalld/zones/   
/usr/lib/firewalld/services/   
用户自己配置的目录  
/etc/firewalld/zones/  
/etc/firewalld/services/  

只允许指定ip访问对应的服务，利用富语言风格配置指令，比如只允许10.0.0.2 访问mysql  
firewall-cmd --add-rich-rule="rule family='ipv4' source address='10.0.0.2' port port='3306' protocol='tcp' accept"  
