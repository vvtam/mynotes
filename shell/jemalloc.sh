#!/bin/bash

src_dir="/web/soft"
jemalloc_ver="5.2.1"
OS_BIT="64"
OS="CentOS"

if [ ! -e "/usr/local/lib/libjemalloc.so" ]; then
  pushd ${src_dir}/src > /dev/null
  tar xjf jemalloc-${jemalloc_ver}.tar.bz2
  pushd jemalloc-${jemalloc_ver} > /dev/null
  ./configure
  make -j $nproc && make install
  popd > /dev/null
  if [ -f "/usr/local/lib/libjemalloc.so" ]; then
    if [ "${OS_BIT}" == '64' -a "${OS}" == 'CentOS' ]; then
      ln -s /usr/local/lib/libjemalloc.so.2 /usr/lib64/libjemalloc.so.1
    else
      ln -s /usr/local/lib/libjemalloc.so.2 /usr/lib/libjemalloc.so.1
    fi
    [ -z "`grep /usr/local/lib /etc/ld.so.conf.d/*.conf`" ] && echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
    ldconfig
    echo "jemalloc module installed successfully!"
    rm -rf jemalloc-${jemalloc_ver}
  else
    echo "jemalloc install failed, Please contact the author!" && lsb_release -a
    kill -9 $$
  fi
  popd > /dev/null
fi
