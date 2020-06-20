wget https://www.haproxy.org/download/2.0/src/haproxy-2.0.13.tar.gz

yum -y install readline-devel systemd-devel pcre-devel openssl-devel
## lua
curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
tar zxvf lua-5.3.5.tar.gz
cd lua-5.3.5
make linux test

## haproxy
make -j $(nproc) TARGET=linux-glibc \
USE_OPENSSL=1 USE_ZLIB=1 \
USE_LUA=1 LUA_INC=/root/lua-5.3.5/src LUA_LIB=/root/lua-5.3.5/src \
USE_PCRE=1 USE_SYSTEMD=1