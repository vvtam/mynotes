##nginx##
docker run --name nginx-8181-walle -d -p 8181:80 -v /home/walle/:/usr/share/nginx/html ad63790cbf0a  
运行一个名为nginx-8181-walle的nginx实例，镜像80端口映射到实体的8181，镜像的/usr/share/nginx/html映射到实体的/home/walle ,ad63790cbf0a是镜像ID  
-v 数据卷，可以用来存放代码  
##php,php-fpm##


