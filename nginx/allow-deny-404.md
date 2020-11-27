        error_page 403 404 /404.html;
        location = /404.html {
            internal; #return 404
        }
    
        location /admin {
            allow 12.18.12.17;
            deny all;
            if (!-e $request_filename) {
                proxy_pass http://127.0.0.1:8082;
            }
        }