#!/bin/bash

pwd_dir=$(pwd)
run_user=www
pureftpd_ver=1.0.49
pureftpd_install_dir=/usr/local/pureftpd

Install_PureFTPd() {
  pushd ${pwd_dir}/src > /dev/null
  id -u ${run_user} >/dev/null 2>&1
  [ $? -ne 0 ] && useradd -M -s /sbin/nologin ${run_user}

  tar xzf pure-ftpd-${pureftpd_ver}.tar.gz
  pushd pure-ftpd-${pureftpd_ver} > /dev/null
  [ ! -d "${pureftpd_install_dir}" ] && mkdir -p ${pureftpd_install_dir}
  ./configure --prefix=${pureftpd_install_dir} CFLAGS=-O2 --with-puredb --with-quotas --with-cookie --with-virtualhosts --with-virtualchroot --with-diraliases --with-sysquotas --with-ratios --with-altlog --with-paranoidmsg --with-shadow --with-welcomemsg --with-throttling --with-uploadscript --with-language=english --with-tls
  make -j $(nproc) && make install
  popd > /dev/null
  if [ -e "${pureftpd_install_dir}/sbin/pure-ftpwho" ]; then
    if [ -e /bin/systemctl ]; then
      /bin/cp ../init.d/pureftpd.service /lib/systemd/system/
      sed -i "s@/usr/local/pureftpd@${pureftpd_install_dir}@g" /lib/systemd/system/pureftpd.service
      systemctl enable pureftpd
    else
      /bin/cp ../init.d/Pureftpd-init /etc/init.d/pureftpd
      sed -i "s@/usr/local/pureftpd@${pureftpd_install_dir}@g" /etc/init.d/pureftpd
      chmod +x /etc/init.d/pureftpd
      [ "${PM}" == 'yum' ] && { chkconfig --add pureftpd; chkconfig pureftpd on; }
      [ "${PM}" == 'apt-get' ] && { sed -i 's@^. /etc/rc.d/init.d/functions@. /lib/lsb/init-functions@' /etc/init.d/pureftpd; update-rc.d pureftpd defaults; }
    fi

    [ ! -e "${pureftpd_install_dir}/etc" ] && mkdir ${pureftpd_install_dir}/etc
    /bin/cp ../config/pure-ftpd.conf ${pureftpd_install_dir}/etc
    sed -i "s@^PureDB.*@PureDB  ${pureftpd_install_dir}/etc/pureftpd.pdb@" ${pureftpd_install_dir}/etc/pure-ftpd.conf
    sed -i "s@^LimitRecursion.*@LimitRecursion  65535 8@" ${pureftpd_install_dir}/etc/pure-ftpd.conf
    IPADDR=${IPADDR:-127.0.0.1}
    [ ! -d /etc/ssl/private ] && mkdir -p /etc/ssl/private
    openssl dhparam -out /etc/ssl/private/pure-ftpd-dhparams.pem 2048
    openssl req -x509 -days 7300 -sha256 -nodes -subj "/C=CN/ST=Shanghai/L=Shanghai/O=OneinStack/CN=${IPADDR}" -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem
    chmod 600 /etc/ssl/private/pure-ftpd*.pem
    sed -i "s@^# TLS.*@&\nCertFile                   /etc/ssl/private/pure-ftpd.pem@" ${pureftpd_install_dir}/etc/pure-ftpd.conf
    sed -i "s@^# TLS.*@&\nTLSCipherSuite             HIGH:MEDIUM:+TLSv1:\!SSLv2:\!SSLv3@" ${pureftpd_install_dir}/etc/pure-ftpd.conf
    sed -i "s@^# TLS.*@TLS                        1@" ${pureftpd_install_dir}/etc/pure-ftpd.conf
    ulimit -s unlimited
    service pureftpd start

    echo "Pure-Ftp installed successfully!"
    rm -rf pure-ftpd-${pureftpd_ver}
  else
    rm -rf ${pureftpd_install_dir}
    echo "Pure-Ftpd install failed, Please contact the author!" && lsb_release -a
    kill -9 $$
  fi
  popd > /dev/null
}

# install pure-ftpd
Install_PureFTPd
