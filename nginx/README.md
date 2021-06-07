## 隐藏版本号

配置为：server_tokens build; 需要编译的时候加 `--build=name`

会显示为`nginx/1.18.0(name)` 样式

```
Syntax:	server_tokens on | off | build | string;
Default:	
server_tokens on;
Context:	http, server, location
```

### 修改源代码

建议按需修改头文件

```
修改头文件
src/core/nginx.h:#define NGINX_VERSION      "1.18.0"
src/core/nginx.h:#define NGINX_VER          "nginx/" NGINX_VERSION
src/core/nginx.h:#define NGINX_VER_BUILD    NGINX_VER " (" NGX_BUILD ")"
src/core/nginx.h:#define NGINX_VER_BUILD    NGINX_VER

header返回信息的源文件？
src/http/ngx_http_header_filter_module.c:static u_char ngx_http_server_string[] = "Server: nginx" CRLF;
src/http/ngx_http_header_filter_module.c:static u_char ngx_http_server_full_string[] = "Server: " NGINX_VER CRLF;
src/http/ngx_http_header_filter_module.c:static u_char ngx_http_server_build_string[] = "Server: " NGINX_VER_BUILD CRLF;

错误页显示版本号的源文件？
src/http/ngx_http_special_response.c:"<hr><center>" NGINX_VER "</center>" CRLF
src/http/ngx_http_special_response.c:"<hr><center>" NGINX_VER_BUILD "</center>" CRLF
```

## POST 静态页面405

## location

```
Syntax:	location [ = | ~ | ~* | ^~ ] uri { ... }
location @name { ... }
Default:	—
Context:	server, location
```

```
location = / {
    [ configuration A ]
}

location / {
    [ configuration B ]
}

location /documents/ {
    [ configuration C ]
}

location ^~ /images/ {
    [ configuration D ]
}

正则不区分大小写， ~ 区分大小写
location ~* \.(gif|jpg|jpeg)$ {
    [ configuration E ]
}
注意末尾的"/"
location /dir1/dir2/dir3/ {
  proxy_pass http://url/dir1/dir2/dir3/;
}

```

The “/” request will match configuration A, the “/index.html” request will match configuration B, the “/documents/document.html” request will match configuration C, the “/images/1.gif” request will match configuration D, and the “/documents/1.jpg” request will match configuration E

location匹配步骤：

1. 前缀字符串匹配URI(`~`和`~*`是正则，`=`、`^~`及`无修饰符`都是前缀字符串)；
2. 如果匹配到`=`号修饰的字符串，则终止匹配，进入该location执行；
3. 如果没有`=`号修饰的字符串，则继续匹配普通前缀字符串(`^~`和`无修饰符`)；
4. 如果匹配到`^~`或`无修饰符`的URI，则查看最长的那一个是否用`^~`修饰；
5. 如果最长的那个有用`^~`修饰，则终止匹配；
6. 如果这个“最长”的匹配没有用`^~`修饰(`无修饰符`)，则暂时存储下来，继续进行后面的正则匹配；
7. 匹配到第一个正则表达式后终止匹配，使用对应的location；
8. 如果没有匹配到正则表达式，则使用之前存储的前缀字符串对应的location。

正则出现的顺序很重要，越精细的正则匹配应该放到前面
