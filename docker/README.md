## 创建镜像

### 基于镜像的容器，commit

`docker run -it xxx /bin/sh`

`docker commit -m 'Commit message' -a "Author" container_id new_image_name`

### 本地模板导入

`cat ubuntu-14.04-x86_64-minimal.tar.gz | docker import - ubuntu:14.04`

`docker save -o image_name.tar image_name`

`docker load --input image_name.tar`

`docker load < image_name.tar` 

### Dockerfile

## 创建容器

```
docker create -it ubuntu
docker start container_id
```

```
docker run # create and start
```

### 进入容器

#### attach

`docker attach`  #退出 ctrl-p-q

#### exec

#### nsenter

`container_PID=$(docker inspect --format "{{ .State.Pid }}" container_id)`

`nsenter --target  container_PID --mount --uts --ipc --net --pid`

## 导入导出容器

`docker export  -o xxx.tar container`

`docker import xxx.tar`

## 创建本地registry

`docker run -d -p 6000:6000 registry`

```
# cat /etc/docker/daemon.json
{"registry-mirrors": ["http://f1361db2.m.daocloud.io"],
 "insecure-registries": ["http://192.168.2.62:5000"]
}
```

## 数据

-v

--volumes-from

## 容器访问

-p -P

容器互联，使用容器名称 --link `--link name：alias`

## Dockerfile

```
FROM ubuntu
MAINTAINER XX XX@XX.NET
RUN xx # 执行一条run命令，镜像就添加新的一层，并提交
CMD xx # 运行容器时执行
EXPOSE 声明镜像内服务监听端口
ENV 环境变量
ADD 复制文件，可以为URL，会自动解压tar
COPY 复制文件，推荐不使用ADD
ENTRYPOINT 镜像默认入口
```

```
RUN[xxx] # 使用exec执行
RUN xxx 使用 /bin/sh -c 执行
CMD["executable"，"param1"，"param2"]使用exec执行，是推荐使用的方式；
CMD command param1 param2在/bin/sh中执行，提供给需要交互的应用；
CMD["param1"，"param2"]提供给ENTRYPOINT的默认参数。
```

