 `# systemctl reload sshd`

禁用 telnet, rsh, rlogin, and ftp等

禁用密码登录，启用key登录  
`PasswordAuthentication no`

使用 RSA, ECDSA, and Ed25519 类型的key  
```
# HostKey /etc/ssh/ssh_host_rsa_key
# HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
```
修改默认端口  
update the default SELinux policy to allow the use of a non-default port. To do so, use the semanage tool from the policycoreutils-python-utils package:

`# semanage port -a -t ssh_port_t -p tcp port_number`
```
# firewall-cmd --add-port port_number/tcp
# firewall-cmd --runtime-to-permanent
```
禁用root密码登录  
`PermitRootLogin prohibit-password`

限制特点用户，组，domains登录
```
AllowUsers *@192.168.1.*,*@10.0.0.*,!*@192.168.1.2
AllowGroups example-group
```
