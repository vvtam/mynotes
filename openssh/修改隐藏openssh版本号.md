修改源码目录下的 version.h 文件

```
/* $OpenBSD: version.h,v 1.86 2020/02/14 00:39:20 djm Exp $ */

#define SSH_VERSION	"OpenSSH_8.2"

#define SSH_PORTABLE	"p1"
#define SSH_RELEASE	SSH_VERSION SSH_PORTABLE
```

然后在编译安装