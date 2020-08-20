#!/bin/bash

openssl_ver=
openssl_install_dir=/usr/local/openssl

tar xf openssl-${openssl_ver}.tar.gz
pushd openssl-${openssl_ver} > /dev/null
make clean
./config -Wl,-rpath=${openssl_install_dir}/lib -fPIC --prefix=${openssl_install_dir} --openssldir=${openssl_install_dir} shared

make depend
make -j $(nproc) && make install
popd > /dev/null
rm -rf openssl-${openssl_ver}

cp $(which openssl){,-bak}
ln -sf ${openssl_install_dir}/bin/openssl $(which openssl)