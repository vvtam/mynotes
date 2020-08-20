#!/bin/bash

workdir=$(pwd)

tar xf bash-5.0.tar.gz
pushd bash-5.0
./configure
make -j$(nproc)
make install
popd
rm -rf bash-5.0

echo "/usr/local/bin/bash" >> /etc/shells
chsh -s "/usr/local/bin/bash"

cp /bin/bash{,-bak}
ln -f -s /usr/local/bin/bash /bin/bash