# docker常用操作

## mysql

* Starting a MySQL instance like this:  
`$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag`  
* Connect to MySQL from an application in another Docker container  
`$ docker run --name some-app --link some-mysql:mysql -d application-that-uses-mysql`  
* Connect to MySQL from the MySQL command line client  
`$ sudo docker run -it --link test-mysql:mysql --rm mysql:5.7.11 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'`  
* Container shell access and viewing MySQL logs  
`$ docker exec -it some-mysql bash`  
* The MySQL Server log is available through Docker's container log:  
`$ docker logs some-mysql`  

## 容器链接

* Run MySQL Container  
`$ sudo docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql`  
see https://github.com/docker-library/docs/tree/master/mysql

* Run WWW Container  
`$ sudo docker run --name www -d micooz/www`

* Run PHP-FPM Container  
`$ sudo docker run --name php-fpm --volumes-from www --link mysql:mysql -d micooz/php-fpm`
`docker run --name epg-php-fpm --link epg-mysql:mysql --link epg-redis:redis -v /home/data/www:/var/www/html -d php:7.0.4-fpm`  
see https://github.com/docker-library/docs/tree/master/php

* Run Nginx Container  
`$ sudo docker run --name nginx -p 80:80 -p 443:443 --volumes-from www --link php-fpm:fpmservice -d micooz/nginx`  
`docker run --name epg-nginx --link epg-php-fpm:php-fpm -v /home/data/conf/nginx/nginx.conf:/etc/nginx/nginx.conf -d -p 80:80 --volumes-from=epg-php-fpm nginx:1.8`
see https://github.com/docker-library/docs/tree/master/nginx

