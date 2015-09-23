##编译安装SVN##
*系统自带svn因为不是用的openssl，使用起来会存在问题，所以自己编译*           
- neon-0.29.6       
./configure --with-ssl=openssl   
make   
make install   

- apr    
tar zvxf apr-1.5.0.tar.gz   
cd apr-1.5.0   
./configure   
make   
make install   

- apr-util    
tar zvxf apr-util-1.5.3.tar.gz    
cd apr-util-1.5.3   
./configure --with-apr=/usr/local/apr   
make   
make install   

- sqllite    
unzip sqlite-amalgamation-3080401.zip    
mv sqlite-amalgamation-3080401 sqlite-amalgamation    
mv sqlite-amalgamation subversion-1.8.8/	// 将其复制到subversion源码目录下    

- subversion    
tar zvxf subversion-1.7.16.tar.gz    
./configure --with-ssl --with-neon --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr    
make    
make install    
/usr/local/bin/svn