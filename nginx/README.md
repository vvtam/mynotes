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
```

The “/” request will match configuration A, the “/index.html” request will match configuration B, the “/documents/document.html” request will match configuration C, the “/images/1.gif” request will match configuration D, and the “/documents/1.jpg” request will match configuration E.

