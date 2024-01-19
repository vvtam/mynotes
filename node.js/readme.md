## nvm安装node，npm安装包
```
http://registry.npmmirror.com
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
nvm install 14.15.0

npm --registry https://registry.npm.taobao.org install
npm --registry https://registry.npm.taobao.org install -g pm2

npm run build  

pm2 start npm --name app-name -- start
```

## 4. 多节点部署

多节点部署时，建议在一台服务器进行构建。然后通过拷贝方式，同步到其他服务器。再通过pm2进行管理工具启动。

> 原因：执行npm run build时，有很少部分的js文件命名会发生变化。导致多节点环境js不一致。出现js文件404问题。

```
#服务器重启的话
#cd ${SERVER_NAME_PATH}/
#手动执行 
#pm2 start --log-date-format "YYYY-MM-DD HH:mm:ss.SSS" npm --name xxx -- start
#再执行
#pm2 save --force
#后续可以正常跑自动发布
```
## pm2 常用命令

```
pm2 start npm --name app-name -- start
pm2 start --log-date-format "YYYY-MM-DD HH:mm:ss.SSS" npm --name app-name -- start

pm2 logs
pm2 delete $id
pm2 list
```

