# 二进制部署k8s组件

## 系统初始化

关闭防火墙

关闭selinux

关闭swap

设置主机名

设置ssh 密钥登录

chrony时间同步

### 签发ssl证书

下载自签证书工具 [cloudflare/cfssl](https://github.com/cloudflare/cfssl/releases)

## etcd

下载地址[Releases-etcd](https://github.com/etcd-io/etcd/releases)

```
mkdir -p /opt/etcd/{bin,cfg,ssl}
```

etcd配置证书

[etcd/hack/tls-setup](https://github.com/etcd-io/etcd/tree/main/hack/tls-setup)

```
# create ca
echo '{"CN":"CA","key":{"algo":"rsa","size":2048}}' | cfssl gencert -initca - | cfssljson -bare ca -
echo '{"signing":{"default":{"expiry":"43800h","usages":["signing","key encipherment","server auth","client auth"]}}}' > ca-config.json
# server
export ADDRESS=127.0.0.1,10.0.1.10,10.0.1.11,10.0.1.12
export NAME=server
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -hostname="$ADDRESS" - | cfssljson -bare $NAME
# peer
export ADDRESS=127.0.0.1,10.0.1.10,10.0.1.11,10.0.1.12
export NAME=peer
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -hostname="$ADDRESS" - | cfssljson -bare $NAME
# client
export ADDRESS=
export NAME=client
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -hostname="$ADDRESS" - | cfssljson -bare $NAME
```

启动

```
/opt/etcd/bin/etcd --name infra0 --initial-advertise-peer-urls https://10.0.1.10:2380 \
  --listen-peer-urls https://10.0.1.10:2380 \
  --listen-client-urls https://10.0.1.10:2379,https://127.0.0.1:2379 \
  --advertise-client-urls https://10.0.1.10:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=https://10.0.1.10:2380,infra1=https://10.0.1.11:2380,infra2=https://10.0.1.12:2380 \
  --initial-cluster-state new \
  --heartbeat-interval=6000 --election-timeout=30000 \
  --client-cert-auth --trusted-ca-file=/root/cfssl/etcd/ca.pem \
  --cert-file=/root/cfssl/etcd/server.pem --key-file=/root/cfssl/etcd/server-key.pem \
  --peer-client-cert-auth --peer-trusted-ca-file=/root/cfssl/etcd/ca.pem \
  --peer-cert-file=/root/cfssl/etcd/server.pem --peer-key-file=/root/cfssl/etcd/server-key.pem
```

检查集群状态

```
/opt/etcd/bin/etcdctl --key="/root/cfssl/etcd/server-key.pem" --cert="/root/cfssl/etcd/server.pem" --insecure-skip-tls-verify=true --endpoints="https://10.0.1.10:2379,https://10.0.1.11:2379,https://10.0.1.12:2379" endpoint health --write-out=table
```

## 安装containerd

`/opt/containerd/bin/containerd config default > /opt/containerd/config.toml`

```
cat >> /usr/lib/systemd/system/containerd.service << EOF
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/opt/containerd/bin/containerd --config /opt/containerd/config.toml
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now containerd
```

