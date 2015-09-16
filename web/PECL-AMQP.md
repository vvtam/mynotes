#编译安装/PECL安装php-amqp插件
插件版本版本选择
rabbitmq-c-0.5.2

< https://github.com/alanxz/rabbitmq-c/releases/download/v0.5.2/rabbitmq-c-0.5.2.tar.gz

如果出现错误，可能缺少头文件，请复制源码目录下面的文件到下列路径

< cp librabbitmq/amqp.h /usr/local/include/
< 
< cp ibrabbitmq/amqp_framing.h /usr/local/include/

其它类推，然后可以用源码或者pecl安装amqp