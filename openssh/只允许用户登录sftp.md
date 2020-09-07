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