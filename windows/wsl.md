# wsl问题记录

## wsl1

### 启用wsl

`dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`

## wsl2

### wsl2和proxifier冲突

1. 下载 [www.proxifier.com/tmp/Test20200228/NoLsp.exe](http://www.proxifier.com/tmp/Test20200228/NoLsp.exe);
2. 使用管理员权限运行：`NoLsp.exe c:\windows\system32\wsl.exe`
3. https://github.com/microsoft/WSL/issues/4177#issuecomment-597736482

### 移除自动加载的window环境变量

建立文件 /etc/wsl.conf 

```
# 不加载Windows中的PATH内容
[interop]
appendWindowsPath = false

# 不自动挂载Windows系统所有磁盘分区
[automount]
enabled = false
```

关闭wsl重启

`wsl --terminate xxx`

### 开启ssh

```
/etc/init.d/ssh start
dpkg-reconfigure openssh-server #sshd error: could not load host key
```

