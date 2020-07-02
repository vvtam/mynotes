# OpenVPN问题
- 报错 tls error 可能是客服端和服务器系统时间不匹配

- 客户端配置非全局vpn

  ```
  route-nopull #添加
  route 192.168.2.0 255.255.255.0 vpn_gateway #按需求添加
  ```

  