##  安装

安装包列表：

- `clickhouse-common-static` — ClickHouse编译的二进制文件。
- `clickhouse-server` — 创建`clickhouse-server`软连接，并安装默认配置服务
- `clickhouse-client` — 创建`clickhouse-client`客户端工具软连接，并安装客户端配置文件。
- `clickhouse-common-static-dbg` — 带有调试信息的ClickHouse二进制文件。

rpm包下载：

https://repo.clickhouse.tech/rpm/stable/x86_64/

安装`clickhouse-server`的提示：

```
Created symlink from /etc/systemd/system/multi-user.target.wants/clickhouse-server.service to /etc/systemd/system/clickhouse-server.service.
ClickHouse binary is already located at /usr/bin/clickhouse
Symlink /usr/bin/clickhouse-server already exists but it points to /clickhouse. Will replace the old symlink to /usr/bin/clickhouse.
Creating symlink /usr/bin/clickhouse-server to /usr/bin/clickhouse.
Creating symlink /usr/bin/clickhouse-client to /usr/bin/clickhouse.
Creating symlink /usr/bin/clickhouse-local to /usr/bin/clickhouse.
Creating symlink /usr/bin/clickhouse-benchmark to /usr/bin/clickhouse.
Symlink /usr/bin/clickhouse-copier already exists but it points to /clickhouse. Will replace the old symlink to /usr/bin/clickhouse.
Creating symlink /usr/bin/clickhouse-copier to /usr/bin/clickhouse.
Creating symlink /usr/bin/clickhouse-obfuscator to /usr/bin/clickhouse.
Creating symlink /usr/bin/clickhouse-git-import to /usr/bin/clickhouse.
Creating symlink /usr/bin/clickhouse-compressor to /usr/bin/clickhouse.
Creating symlink /usr/bin/clickhouse-format to /usr/bin/clickhouse.
Symlink /usr/bin/clickhouse-extract-from-config already exists but it points to /clickhouse. Will replace the old symlink to /usr/bin/clickhouse.
Creating symlink /usr/bin/clickhouse-extract-from-config to /usr/bin/clickhouse.
Creating clickhouse group if it does not exist.
 groupadd -r clickhouse
Creating clickhouse user if it does not exist.
 useradd -r --shell /bin/false --home-dir /nonexistent -g clickhouse clickhouse
Will set ulimits for clickhouse user in /etc/security/limits.d/clickhouse.conf.
Creating config directory /etc/clickhouse-server/config.d that is used for tweaks of main server configuration.
Creating config directory /etc/clickhouse-server/users.d that is used for tweaks of users configuration.
Config file /etc/clickhouse-server/config.xml already exists, will keep it and extract path info from it.
/etc/clickhouse-server/config.xml has /var/lib/clickhouse/ as data path.
/etc/clickhouse-server/config.xml has /var/log/clickhouse-server/ as log path.
Users config file /etc/clickhouse-server/users.xml already exists, will keep it and extract users info from it.
 chown --recursive clickhouse:clickhouse '/etc/clickhouse-server'
Creating log directory /var/log/clickhouse-server/.
Creating data directory /var/lib/clickhouse/.
Creating pid directory /var/run/clickhouse-server.
 chown --recursive clickhouse:clickhouse '/var/log/clickhouse-server/'
 chown --recursive clickhouse:clickhouse '/var/run/clickhouse-server'
 chown clickhouse:clickhouse '/var/lib/clickhouse/'
Password for default user is empty string. See /etc/clickhouse-server/users.xml and /etc/clickhouse-server/users.d to change it.
Setting capabilities for clickhouse binary. This is optional.
 command -v setcap >/dev/null && echo > /tmp/test_setcap.sh && chmod a+x /tmp/test_setcap.sh && /tmp/test_setcap.sh && setcap 'cap_net_admin,cap_ipc_lock,cap_sys_nice+ep' /tmp/test_setcap.sh && /tmp/test_setcap.sh && rm /tmp/test_setcap.sh && setcap 'cap_net_admin,cap_ipc_lock,cap_sys_nice+ep' /usr/bin/clickhouse || echo "Cannot set 'net_admin' or 'ipc_lock' or 'sys_nice' capability for clickhouse binary. This is optional. Taskstats accounting will be disabled. To enable taskstats accounting you may add the required capability later manually."

ClickHouse has been successfully installed.

Start clickhouse-server with:
 sudo clickhouse start

Start clickhouse-client with:
 clickhouse-client
```

## 配置集群

三分片一个复制集，生成环境至少两个复制集

```
    <remote_servers>
    <sx_3shards_1replicas>
        <shard>
            <replica>
                <host>13.136.199.149</host>
                <port>9000</port>
            </replica>
        </shard>
        <shard>
            <replica>
                <host>13.136.199.150</host>
                <port>9000</port>
            </replica>
        </shard>
        <shard>
            <replica>
                <host>13.136.199.151</host>
                <port>9000</port>
            </replica>
        </shard>
    </sx_3shards_1replicas>
    </remote_servers>
```

添加zookeeper

```
    <zookeeper>
        <node>
            <host>13.136.199.149</host>
            <port>2181</port>
        </node>
        <node>
            <host>13.136.199.150</host>
            <port>2181</port>
        </node>
        <node>
            <host>13.136.199.151</host>
            <port>2181</port>
        </node>
    </zookeeper>

    <!-- Substitutions for parameters of replicated tables.
          Optional. If you don't use replicated tables, you could omit that.

         See https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/replication/#creating-replicated-tables
      -->
    <macros>
        <shard>01</shard>
        <replica>01</replica>
    </macros>
```



## 导入数据

`clickhouse-client --user 用户名 --password 密码 -d 数据库 --multiquery <  /root/temp.sql`