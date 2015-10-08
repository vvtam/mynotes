##tsung是一个分布式的用erlang编写的一个测试工具

###安装
**CentOS release 6.6 (Final)**
```
1.Adding repository entry

To add Erlang Solutions repository (including our public key for verifying signed package) to your system, call the following commands:

wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
Alternatively: adding the repository entry manually

RPM packages are signed. To add Erlang Solutions key, execute command:

rpm --import http://packages.erlang-solutions.com/rpm/erlang_solutions.asc
Add the following lines to some file in /etc/yum.repos.d/:

[erlang-solutions]
name=Centos $releasever - $basearch - Erlang Solutions
baseurl=http://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch
gpgcheck=1
gpgkey=http://packages.erlang-solutions.com/rpm/erlang_solutions.asc
enabled=1
Note that RPM Forge and EPEL must be also added to repos.

2.Installing Erlang

Call the following command:

sudo yum install erlang
```
gnuplot 绘图工具

perl

perl-Template-Toolkit

Tsung
编译 OR
yum -y install erlang perl perl-RRD-Simple.noarch perl-Log-Log4perl-RRDs.noarch gnuplot perl-Template-Toolkit

###分布式
tsung只_识别主机名_，还需要用_密钥登录_其它客户端机器
```
 <clients>
    <client host="localhost" use_controller_vm="true"  maxusers="500000" />
    <client host="TEST-STC-NPSS-02" use_controller_vm="true"  maxusers="500000" />
  </clients>

```
配置好密钥登录和配置完主机名后，需要手动登录一次，比如  
`ssh TEST-STC-NPSS-02`

所有客户端都需要安装erlang环境，安装tsung并加入的PATH  
[FAQ](http://tsung.erlang-projects.org/user_manual/faq.html)
