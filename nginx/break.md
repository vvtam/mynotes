	location /admin {
	        allow ip;
	        deny all;
	        if (!-e $request_filename) {
	            proxy_pass http://127.0.0.1:8083;
	        }
	}