## JVM工具

### jstat

`jstat -gc pid [interval]` 命令查看 java 进程的状态

`jstack pid > jstack.log` 保存线程栈的现场

`jmap -dump:format=b,file=heap.log pid` 保存堆内存

查看线程数

```
> grep 'java.lang.Thread.State' jstack.log  | wc -l
```

```
grep -A 1 'java.lang.Thread.State' jstack.log  | grep -v 'java.lang.Thread.State' | sort | uniq -c |sort -n
```

### 使用 MAT 分析 jvm heap