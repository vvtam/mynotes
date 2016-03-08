#redmine 安装#
**请使用普通用户，不要用root，根据提示用sudo即可**

本文参考  
*http://blog.tc130lab.com/pei-zhi-xue-xi-zheng-li-bi-ji-shi-jian-20150110ling-chen/*
*https://ruby.taobao.org/*
```
环境：
Ubuntu 14.04
nginx 使用passenger带的脚本来安装，或者自己编译（要编译passenger支持）
mysql
ruby rails
```

1. 新增源
 * 新增key和证书
```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7  
sudo apt-get install apt-transport-https ca-certificates  
```
2. 创建apt-get源
```
sudo vim /etc/apt/sources.list.d/passenger.list
添加，保存
deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main  
修改权限并更新
sudo chown root: /etc/apt/sources.list.d/passenger.list  
sudo chmod 600 /etc/apt/sources.list.d/passenger.list  
sudo apt-get update  
sudo apt-get upgrade 
```
3. 安装Ruby以及相关
```
Tip：可以使用taobao的ruby源，比较快速
gem source --remove https://rubygems.org/
gem source --add https://ruby.taobao.com/
gem source -l
使用bundler的gem源代码镜像命令，可以不用修改gemfile的source
bundle config mirror.https://rubygems.org https://ruby.taobao.org
sudo gem update
sudo gem install bundler
```
4. 安装Redmine
下载源码 http://www.redmine.org
比如解压到 /opt/redmin
sudo chown -R root:root redmine  
sudo chown www-data redmine/config/environment.rb 
5. 安装配置mysql
```
安装MySQL略
配置mysql
cd /opt/redmin/conf
sudo cp database.yml.example database.yml
修改 production development test的数据库链接
```
6. 配置redmine
```
cd /opt/redmine/
sudo bundle install --without development test  
sudo rake generate_secret_token  
sudo RAILS_ENV=production rake db:migrate  
sudo RAILS_ENV=production rake redmine:load_default_data  
sudo mkdir public/plugin_assets  
sudo chown -R www-data:www-data files log tmp public/plugin_assets  
sudo chmod -R 755 files log tmp public/plugin_assets  
```
7. 安装passenger，并且用passenger的脚本安装nginx
```
sudo apt-get install passenger
sudo /usr/bin/ruby1.9.1 /usr/bin/passenger-install-nginx-module
根据提示安装配置nginx
以下是nginx.conf样例

#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
    passenger_ruby /usr/bin/ruby1.9.1;
    #rails_env development;
    #passenger_friendly_error_pages on;

    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   /opt/redmine;
            passenger_enabled on;
            passenger_base_uri /redmine;
            passenger_app_root /opt/redmine;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}
```
8. 邮件配置

```
config/configuration.yml
email_delivery:
    delivery_method: :smtp
    smtp_settings:
      tls: false
      address: smtp.ym.163.com
      port: 25
      domain: example.net
      authentication: :login
      enable_starttls_auto: true
      user_name: xxx@xxx.xxx
      password: yourpasswd 
```
