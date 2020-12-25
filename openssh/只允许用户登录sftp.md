sshd_config

```
# override default of no subsystems
Subsystem	sftp	internal-sftp
#Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server

Match User www
        ChrootDirectory /home/www/
        X11Forwarding no
        AllowTcpForwarding no
        PermitTTY no
        ForceCommand internal-sftp
```

sftp不能使用软链接，可以使用 mount -o bind [--bind,-B]

用户目录权限配置，例如：

```
www 用户，/home/www/， ls -d /home/www/ 看到的权限为root用户，或其他www没有权限的用户，但是有x权限，可以cd进入目录，然后/home/www/ 下再配置其它目录为www权限，否者连接sftp会报权限错误
```

