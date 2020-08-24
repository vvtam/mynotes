#!/bin/bash
export JAVA_OPTS="-Xms1g -Xmx2g"
export JAVA_HOME="/data/jdk1.8.0_251"
export JRE_HOME="/data/jdk1.8.0_251/jre"
export CATALINA_HOME="/data/tomcat" #bin,lib所在目录
export CATALINA_BASE=$(pwd) #conf所在目录
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib

case $1 in
    start)
        $CATALINA_HOME/bin/catalina.sh start
        echo start success!!
        ;;
    stop)
        $CATALINA_HOME/bin/catalina.sh stop
        echo stop success!!
        ;;
    restart)
        $CATALINA_HOME/bin/catalina.sh stop
        echo stop success!!
        sleep 2
        $CATALINA_HOME/bin/catalina.sh start
        echo start success!!
        ;;
    version)
        $CATALINA_HOME/bin/catalina.sh version
        ;;
    configtest)
        $CATALINA_HOME/bin/catalina.sh configtest
        ;;
    *)
        echo 'Usage: '$0' start|stop|restart|version|configtest'
        ;;
esac
exit 0
