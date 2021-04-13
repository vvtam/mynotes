## containerd,nerdctl

### 下载

```shell
wget https://github.com/containerd/containerd/releases/download/v1.4.4/containerd-1.4.4-linux-amd64.tar.gz
wget https://github.com/containerd/nerdctl/releases/download/v0.7.3/nerdctl-0.7.3-linux-amd64.tar.gz
```

### 安装

解压到目录，加入PATH

`tar Czxvvf   ~/.local/  containerd-1.4.4-linux-amd64.tar.gz`

``tar Czxvvf   ~/.local/  nerdctl-0.7.3-linux-amd64.tar.gz`

`export PATH=$PATH:~/.local/bin`

### root启动Rootful

```
$ sudo systemctl enable --now containerd
$ sudo nerdctl run -d --name nginx -p 80:80 nginx:alpine
```

### 非root启动Rootless

```
$ containerd-rootless-setuptool.sh install
$ nerdctl run -d --name nginx -p 8080:80 nginx:alpine
```

### cni plugin

```
FATA[0015] needs CNI plugin "bridge" to be installed in CNI_PATH ("/opt/cni/bin"), see https://github.com/containernetworking/plugins/releases: exec: "/opt/cni/bin/bridge": stat /opt/cni/bin/bridge: no such file or directory
```

