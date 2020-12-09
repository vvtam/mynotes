## starce

system call trace

```
# strace cat /dev/null

execve("/usr/bin/cat", ["cat", "/dev/null"], 0x7ffc78980438 /* 19 vars */) = 0
brk(NULL)                               = 0x55cfe27f2000
...
openat(AT_FDCWD, "/dev/null", O_RDONLY) = 3
fstat(3, {st_mode=S_IFCHR|0666, st_rdev=makedev(0x1, 0x3), ...}) = 0
fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
mmap(NULL, 139264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f472ee19000
read(3, "", 131072)                     = 0
munmap(0x7f472ee19000, 139264)          = 0
close(3)                                = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++

#
fork() > exec(), strace work after the fork()
brk(), a memory initialization
The 3 is a result that means success (3 is the file descriptor that the kernel returns after opening the file)
```

```
# strace cat /dev/null2
execve("/usr/bin/cat", ["cat", "/dev/null2"], 0x7ffdf90eae98 /* 19 vars */) = 0
brk(NULL)                               = 0x55f15c531000
...
openat(AT_FDCWD, "/dev/null2", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "cat: ", 5cat: )                    = 5
write(2, "/dev/null2", 10/dev/null2)              = 10
openat(AT_FDCWD, "/usr/share/locale/en_US.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en_US.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, ": No such file or directory", 27: No such file or directory) = 27
write(2, "\n", 1
)                       = 1
close(1)                                = 0
close(2)                                = 0
exit_group(1)                           = ?
+++ exited with 1 +++
```

`strace -o crummyd_strace -ff command`