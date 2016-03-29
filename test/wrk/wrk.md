#wrk，类似ab webbench的工具

##介绍
https://github.com/wg/wrk

##安装
https://github.com/wg/wrk/wiki/Installing-Wrk-on-Linux

##常见用法

> ./wrk -t16 -c30000 -d60s -T30s "http://192.168.90.61:8080/index.html"

*-t 表示线程数量，一般cpu核心的2-4倍*    
*-c 并发数量*    
*-d 时间*    
*-T 超时时间*    
