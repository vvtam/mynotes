# 在线编译升级nginx

## 编译安装nginx

## 在线升级nginx版本
```
# 备份nginx老版本
cp nginx nginx-old
# 替换为nginx新版本
cp nginx-new nginx

# 开启新的nginx进程
kill -USR2 oldpid
# 停止老的worker进程
kill -WINCH oldpid
# 停止老的master进程
kill -QUIT oldpid
```

- 备份旧的二进制文件,然后将新的二进制文件覆盖旧的二进制文件

- 向nginx master pid发送USR2信号

  ```
  kill -USR2 nginx-old-master-pid
  ```

  此时nginx首先会将保存pid值的nginx.pid rename为nginx.pid.oldbin,然后使用新的二进制文件开启nginx
  此时会有两组master和两组worker同时提供服务

- 向旧的nginx master pid发送WINCH信号

  ```
  kill -WINCH nginx-old-master-pid
  ```

  旧的master收到该信号后会向旧的worker发送信息,要求他们优雅关闭-即处理完请求后退出

- 此时有两种情况,如果新的nginx工作正常,那么发送QUIT信号给旧的master,升级完毕
  如果新的nginx工作不正常,那么可以发送HUP信号给旧的master,旧master会重新启动worker而且不会重读配置(即保持旧有的配置不变),然后发送QUIT信号给新的master要求退出,也可以直接发送TERM命令给新master,新master退出后旧master会重启worker process.
