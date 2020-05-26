#!/bin/bash

workdir=$(pwd)
installdir=/web/soft
nginxversion=1.16.0

yum install -y pcre pcre-devel openssl-devel openssl zlib zlib-devel

useradd -M -s /sbin/nologin nginx

tar -zxvf $workdir/nginx-"$nginxversion".tar.gz -C $workdir
cd $workdir/nginx-$nginxversion
./configure --prefix="$installdir"/nginx  --user=nginx  --group=nginx  --with-http_stub_status_module --with-http_ssl_module --with-pcre --with-stream --with-http_v2_module && make -j$(nproc) && make install
rm -rf $workdir/nginx-$nginxversion