# android

## wifi出现感叹号，并且提示wifi没有链接到互联网

应该是android 5.0开始引入的新机制，会连接google的服务器来评估网络情况。  
所有可以把检测的网址替换掉，或者关闭此功能。  
具体就是返回一个204，空内容。  

```
settings put global captive_portal_detection_enabled 0   #关闭  
settings put global captive_portal_detection_enabled 1   #恢复  

settings put global captive_portal_server g.cn           #替换    
settings delete global captive_portal_server             #恢复  
```



以上可以在adb 执行，也可以机器上开一个终端来执行(需要root权限)。  

