# RabbitMQ安装配置

## 安装服务端
官网：http://www.rabbitmq.com/download.html
下载适合操作系统的正确版本，编译安装，默认配置即可
可能会提示缺少依赖，请安装对应包，比如erlang libxslt nc xmlto 等

>make install的需要指定三个目录#
>启用插件的时候需要建一个文件，不是文件夹#
>/etc/rabbitmq/enabled_plugins

启动服务：sbin/rabbitmq-server 
后台运行需要加参数 sbin/rabbitmq-server -detached

### 监控
RabbitMQ是通过插件来进行监控的。插件位置都是在安装目录的plugins目录下面
启动监控界面：
rabbitmq-plugins enable rabbitmq_management
启动成功之后 UI访问：http://server-name:15672/
用户名密码：guest guest
只能本地访问，如果需要外部访问需要新建用户

### 配置用户
vim /etc/rabbitmq/rabbitmq.config
    [
        {rabbit, [{tcp_listeners, [5672]}, {loopback_users, ["admin"]}]}
    ].
 rabbitmqctl add_user admin admin
 rabbitmqctl set_user_tags admin  administrator
 rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"

### 配置
RabbitMQ-Server默认配置即可满足我们的需求，但是为了避免日增量大，出现堵塞情况，我们需要配置一下队列的最大长度。
name：队列名称
max-length：长度  20000
### 停止服务
rabbitmqctl stop

## Rabbit-client客户端
### PHP扩展
需要安装php-amqp扩展（扩展版本号：1.4.0）
下载地址：http://pecl.php.net/package/amqp 
安装完成之后，使用php  -m 命令查看amqp是否安装成功