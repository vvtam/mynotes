##nginx##
docker run --name nginx-8181-walle -d -p 8181:80 -v /home/walle/:/usr/share/nginx/html ad63790cbf0a  
运行一个名为nginx-8181-walle的nginx实例，镜像80端口映射到实体的8181，镜像的/usr/share/nginx/html映射到实体的/home/walle ,ad63790cbf0a是镜像ID  
-v 数据卷，可以用来存放代码  
##php,php-fpm##
docker run --name php7-walle -p 8181:80 -p 8022:22 -v /home/walle/:/var/www/html -d root/php7  

##mysql##
docker run --name mysql-walle -v /data/mysql_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d -p 5006:3306 5c195182ceea  

docker run -d -e MYSQL_ROOT_PASSWORD=admin --name mysql -v /data/mysql/data:/var/lib/mysql -p 3306:3306 mysql 

docker run -d -e MYSQL_ROOT_PASSWORD=admin --name mysql -v /data/mysql/my.cnf:/etc/mysql/my.cnf -v /data/mysql/data:/var/lib/mysql -p 3306:3306 mysql 
