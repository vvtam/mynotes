```
proxy_cache_path /home/www/Webroot/htdocs/cache keys_zone=cache_one:50m levels=1:2
                 inactive=7d loader_threshold=300 loader_files=200 max_size=200m;

    location ~* /interface/launch\/(\d+)/template$ {
        proxy_read_timeout 10s;
        proxy_connect_timeout 10s;
        proxy_set_header Host $host;
        proxy_cache_use_stale updating;
        proxy_cache_key $host$uri;
        proxy_cache cache_one;
        proxy_hide_header "Set-Cookie";
        proxy_ignore_headers "Set-Cookie";
        add_header X-Cache '$upstream_cache_status from $server_addr';
        proxy_cache_valid 200 304 2m;
        proxy_pass http://backend;
        expires 30s;
    }


    location /interface/launch {
        set $business_code $arg_business_code;
        proxy_read_timeout 10s;
        proxy_connect_timeout 10s;
        proxy_set_header Host $host;
        proxy_cache_use_stale updating;
        proxy_cache_key $host$uri$business_code;
        proxy_cache cache_one;
        proxy_hide_header "Set-Cookie";
        proxy_ignore_headers "Set-Cookie";
        add_header X-Cache '$upstream_cache_status from $server_addr';
        proxy_cache_valid 200 304 2m;
        proxy_pass http://backend;
        expires 30s;
    }
```
