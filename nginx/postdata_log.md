log_format postdata '$remote_addr - $remote_user [$time_local] "$request" '
                                    '"$status" $body_bytes_sent "$http_referer" '
                                    '"$http_user_agent" $http_x_forwarded_for "$request_time" '
                                    '$request_body';

access_log path/to/log postdata;
