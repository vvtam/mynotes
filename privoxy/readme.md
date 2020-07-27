## Privoxy

## centos 安装

`yum -y install epel-release`

`yum -y install privoxy`

## 配置

/etc/privoxy/config

```
# 配置的socks5代理
forward-socks5t   /               ip:port .

# action配置，可以配置各类规则，每个规则可以走不通代理
actionsfile match-all.action # Actions that are applied to all sites and maybe overruled later on.
actionsfile default.action   # Main actions file
actionsfile user.action      # User customizations
actionsfile direct.action      # Direct action

```

/etc/privoxy/*.action

```
{{alias}}
direct      = +forward-override{forward .}
ssh         = +forward-override{forward-socks5 127.0.0.1:7000 .}
trojan         = +forward-override{forward 127.0.0.1:8000} 
default     = direct
#==========默认代理==========
{default}
/
#==========直接连接==========
{direct} 
.edu.cn
223.5.5.5
localhost
#==========SSH代理==========
{ssh}
#==========trojan代理==========
{trojan}

```

/etc/privoxy/*.filter

增加过滤规则