salt '*' cmd.run 'echo 'yourpasswd'|passwd root --stdin'

salt-run manage.up

salt-run manage.status

salt '*' file.copy /tmp/zabbix.sls /tmp/sls

salt-cp '*'  /etc/hosts  /etc/hosts

salt '*' cp.get_file salt://ceshi/b /tmp/test

salt '*' cp.get_dir salt://zabbix /tmp