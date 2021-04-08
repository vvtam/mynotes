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

```
java -Xms8096m -Xmx8096m -XX:+UseG1GC -Xloggc:./gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=./heapdump.hprof -Dserver.undertow.worker-threads=1000 -jar demo.jar
-XX:+UseG1GC 垃圾收集器
-Xloggc:./gc.log gc日志
-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=./heapdump.hprof 内存泄漏自动dump

```

`java -Xms8096m -Xmx8096m -XX:+UseG1GC -Xloggc:/web/soft/jar/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/web/soft/jar/heapdump.hprof -Dserver.undertow.worker-threads=1000 -Dspring.profiles.active=deploy -jar $pwds/worker.jar`

### 使用 MAT 分析 jvm heap

