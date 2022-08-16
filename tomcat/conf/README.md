```
        <Context docBase="/dir/to/webapp/" path="" />
```



Steps
server.xml file needs to edited and a new valve needs to be added.

Edit the file <install-directory>/conf/server.xml
Search for the parameters <Host name=
Just below that line, insert the following parameters 

<Valve className="org.apache.catalina.valves.ErrorReportValve" showReport="false" showServerInfo="false" />
Restart application