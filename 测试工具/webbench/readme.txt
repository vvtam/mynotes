
#step1 install
tar xzvf webbench-1.5.tar.gz
make && make install

#step2 test
cd webbench
edit bench.txt
sh bench

�����ʾ
ctags *.c
/bin/sh: ctags: command not found
make: [tags] Error 127 (ignored)

��Ҫ��װctags

#ctags install
./configure
make && make install

#refer
http://home.tiscali.cz:8080/~cz210552/webbench.html
