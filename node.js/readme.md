# nvm安装node，npm安装包
```
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node/
nvm install 14.15.0

npm --registry https://registry.npm.taobao.org install
npm --registry https://registry.npm.taobao.org install -g pm2

pm2 start npm --name app-name -- start
```