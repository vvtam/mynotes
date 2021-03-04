# Cobbler Quick Start

## Installing Cobbler
http://cobbler.github.io/manuals/quickstart/  
follow this manual,but you need to install dhcp and xinetd,if the system did not install before this.  

```
$ yum install cobbler
$ yum install cobbler-web #if you need some web-ui for cobbler
$ yum install -y dhcp
$ yum install -y xinetd 
```
## Changing Settings
Settings for cobbler/cobblerd are stored in /etc/cobbler/settings.  

### Default Encrypted Password
Set the root password for new systems during the kickstart  
`default_password_crypted: "xxxxxx"`   
You should change this by running  
`openssl passwd -1`  

### Server and Next_Server

```
#server your host ip
server 127.0.0.1 
#next_server just the same ip as the server setting
next_server 127.0.0.1
```

### DHCP Management and DHCP Server Template

```
manage_dhcp: 0 
#If you want cobbler to manage your dhcp,chang the setting to 1
```
Changing the DHCP Template at:  
`$ vim /etc/cobbler/dhcp.template`  
```
subnet 192.168.1.0 netmask 255.255.255.0 {
     option routers             192.168.1.1;
     option domain-name-servers 192.168.1.210,192.168.1.211;
     option subnet-mask         255.255.255.0;
     filename                   "/pxelinux.0";
     default-lease-time         21600;
     max-lease-time             43200;
     next-server                $next_server;
}
```
## Starting and Enabling the Cobbler Service

```
systemctl enable cobblerd.service
systemctl enable xinetd.service
systemctl enable httpd.service
systemctl enable dhcpd.service

systemctl start cobblerd.service
systemctl start xinetd.service
systemctl start httpd.service
systemctl start dhcpd.service
```
## Checking for Porblems and YOur First Sync

```
$ cobbler check
$ cobbler sync
```

AND SO ON...
