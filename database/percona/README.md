#percona

##percona toolkit
安装

```
wget https://www.percona.com/downloads/percona-toolkit/3.0.3/binary/tarball/percona-toolkit-3.0.3_x86_64.tar.gz
yum install perl perl-devel perl-Time-HiRes perl-DBI perl-DBD-MySQL perl-CPAN perl-Digest-MD5
perl Makefile.PL
make
make install
```
运行pt-table-checksum
```
pt-table-checksum --nocheck-binlog-format --nocheck-plan --nocheck-replication-filters  --set-vars innodb_lock_wait_timeout=120 --recursion-method=processlist --databases=dbname -u'user' -p'password' -hMasterIP

pt-table-checksum --nocheck-binlog-format --nocheck-plan --nocheck-replication-filters  --set-vars innodb_lock_wait_timeout=120 --recursion-method=processlist --databases=dbname  -u'user' -p'password' --slave-user='' --slave-password='' -hMasterIP
```
##Percona Xtrabackup

```
# 第一次完整备份
./innobackupex --defaults-file=/etc/my.cnf --user=root --password='password' /home/pxb_backup/full
# 第二次把日志写入
./innobackupex --defaults-file=/etc/my.cnf --user=root --password='password' --apply-log /home/pxb_backup/full/时间

# 恢复

恢复准备
./innobackupex --defaults-file=/etc/my.cnf --user=root --password='password' --use-memory=16G --apply-log /home/pxb_backup/full/2017-05-27_17-06-51/

确认数据库是关闭的，并且datadir，目录下为空(一般备份之前目录，新建mysql的各种目录)
./innobackupex --defaults-file=/etc/my.cnf --user=root --password='password' --use-memory=16G --copy-back /home/pxb_backup/full//home/pxb_backup/full/2017-05-27_17-06-51/
```
