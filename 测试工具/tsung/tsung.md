##tsung是一个分布式的用erlang编写的一个测试工具

###安装
**CentOS release 6.6 (Final)**
- erlang

> RPM packages are signed. To add Erlang Solutions key, execute command:    
rpm --import http://packages.erlang-solutions.com/rpm/erlang_solutions.asc    
Add the following lines to some file in /etc/yum.repos.d/:
> 
[erlang-solutions]    
name=Centos $releasever - $basearch - Erlang Solutions    
baseurl=http://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch    
gpgcheck=1    
gpgkey=http://packages.erlang-solutions.com/rpm/erlang_solutions.asc    
enabled=1    

> **Note that RPM Forge and EPEL must be also added to repos.**

> RPM Forge    
https://wiki.centos.org/AdditionalResources/Repositories/RPMForge    
i686 http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.i686.rpm
x86_64 http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

> EPEL    
https://fedoraproject.org/wiki/EPEL

- gnuplot 绘图工具
- perl
- perl-Template-Toolkit
- Tsung
编译 OR
yum -y install erlang perl perl-RRD-Simple.noarch perl-Log-Log4perl-RRDs.noarch gnuplot perl-Template-Toolkit
