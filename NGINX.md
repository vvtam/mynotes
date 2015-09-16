#nginx使用遇到的一些问题
- nginx出现502，如果是后端是php-fpm，可能需要调整php-fpm的参数，比如
< pm.max_children
< 
< pm.max_spare_servers