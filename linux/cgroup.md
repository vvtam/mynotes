# cgroup

## 基本概念

cgroup是linux kernel 的一项功能，主要进行资源的分配控制（cpu时间，内存，带宽等）

cgroup和namespace类似，进行进程分组，但是namespace是为了隔离进程资源，cgroup是为了对一组进程进行统一的资源监控和限制

cgroup 分为 v1，v2

### subsystem



### hierarchy

### systemctl管理

```bash
$ systemctl set-property user-1000.slice CPUQuota=20%
```

```bash
$ systemctl set-property user-1000.slice
AccuracySec=            CPUAccounting=          Environment=            LimitCPU=               LimitNICE=              LimitSIGPENDING=        SendSIGKILL=
BlockIOAccounting=      CPUQuota=               Group=                  LimitDATA=              LimitNOFILE=            LimitSTACK=             User=
BlockIODeviceWeight=    CPUShares=              KillMode=               LimitFSIZE=             LimitNPROC=             MemoryAccounting=       WakeSystem=
BlockIOReadBandwidth=   DefaultDependencies=    KillSignal=             LimitLOCKS=             LimitRSS=               MemoryLimit=
BlockIOWeight=          DeviceAllow=            LimitAS=                LimitMEMLOCK=           LimitRTPRIO=            Nice=
BlockIOWriteBandwidth=  DevicePolicy=           LimitCORE=              LimitMSGQUEUE=          LimitRTTIME=            SendSIGHUP=
```

或者直接配置文件

```bash
$ cat /run/systemd/system/user-1000.slice.d/50-CPUQuota.conf
[Slice]
CPUQuota=20%
```

## cpu

systemd-cgls --no-page 查看cgroup信息

```
Control group /:
-.slice
├─user.slice
│ ├─user-0.slice
│ │ ├─session-34.scope
...

```

systemd-cgtop 动态查看

开启资源统计

```bash
$ systemctl set-property sshd.service CPUAccounting=true MemoryAccounting=true
```

## 内存

```bash
$ systemctl set-property user-1000.slice MemoryLimit=200M
```

```bash
$ stress --vm 8 --vm-bytes 256M
```

物理内存，交换空间swap