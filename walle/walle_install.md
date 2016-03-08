#walle安装#
请参考官方安装文档  
**https://doc.huamanshu.com/%E7%93%A6%E5%8A%9B/2.%E5%AE%89%E8%A3%85/%E5%AE%89%E8%A3%85.html**

安装Composer，Composer安装vendor，国内网络太差，直接下载vendor放到walle目录下面  
http://pan.baidu.com/s/1c0wiuyc

安装 php nginx mysql 略

配置mysql，如果不是默认端口  
```
'db' => [
    'dsn'       => 'mysql:host=127.0.0.1;port=xxxx;dbname=walle', # 新建数据库walle
    'username'  => 'username',                          # 连接的用户名
    'password'  => 'password',  
```
初始化项目  
./yii walle/setup  

nginx配置
```
server {
    listen       80;
    server_name  walle.compony.com; # 改你的host
    root /the/dir/of/walle-web/web; # 根目录为web
    index index.php;

    # 建议放内网
    # allow 192.168.0.0/24;
    # deny all;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri = 404;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```
