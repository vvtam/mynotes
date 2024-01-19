# Percona MySQL Server安装说明

```
-------------
   *  The suggested mysql options and settings are in /etc/percona-server.conf.d/mysqld.cnf
   *  If you want to use mysqld.cnf as default configuration file please make backup of /etc/my.cnf
   *  Once it is done please execute the following commands:
 rm -rf /etc/my.cnf
 update-alternatives --install /etc/my.cnf my.cnf "/etc/percona-server.cnf" 200
 -------------
Percona Server is distributed with several useful UDF (User Defined Function) from Percona Toolkit.
Run the following commands to create these functions:
mysql -e "CREATE FUNCTION fnv1a_64 RETURNS INTEGER SONAME 'libfnv1a_udf.so'"
mysql -e "CREATE FUNCTION fnv_64 RETURNS INTEGER SONAME 'libfnv_udf.so'"
mysql -e "CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so'"
See http://www.percona.com/doc/percona-server/5.7/management/udf_percona_toolkit.html for more details


 * This release of Percona Server is distributed with RocksDB storage engine.
 * Run the following script to enable the RocksDB storage engine in Percona Server:

	ps-admin --enable-rocksdb -u <mysql_admin_user> -p[mysql_admin_pass] [-S <socket>] [-h <host> -P <port>]


 * This release of Percona Server is distributed with TokuDB storage engine.
 * Run the following script to enable the TokuDB storage engine in Percona Server:

	ps-admin --enable-tokudb -u <mysql_admin_user> -p[mysql_admin_pass] [-S <socket>] [-h <host> -P <port>]

 * See http://www.percona.com/doc/percona-server/5.7/tokudb/tokudb_installation.html for more installation details

 * See http://www.percona.com/doc/percona-server/5.7/tokudb/tokudb_intro.html for an introduction to TokuD
 ```