## pidstat

-r memory

-d disk

```
# pidstat -r -p 2627 1
Linux 4.18.0-193.19.1.el8_2.x86_64 (vm213.rhel8) 	12/07/2020 	_x86_64_	(24 CPU)

05:03:58 PM   UID       PID  minflt/s  majflt/s     VSZ     RSS   %MEM  Command
05:03:59 PM  1002      2627      0.00      0.00 8036316  574480   6.52  mysqld
05:04:00 PM  1002      2627      0.00      0.00 8036316  574480   6.52  mysqld

# pidstat -d -p 2627 1
Linux 4.18.0-193.19.1.el8_2.x86_64 (vm213.rhel8) 	12/07/2020 	_x86_64_	(24 CPU)

05:04:15 PM   UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s iodelay  Command
05:04:16 PM  1002      2627      0.00      0.00      0.00       0  mysqld
05:04:17 PM  1002      2627      0.00      0.00      0.00       0  mysqld

# pidstat -p 2627 1
Linux 4.18.0-193.19.1.el8_2.x86_64 (vm213.rhel8) 	12/07/2020 	_x86_64_	(24 CPU)

05:04:25 PM   UID       PID    %usr %system  %guest   %wait    %CPU   CPU  Command
05:04:26 PM  1002      2627    0.00    0.00    0.00    0.00    0.00    23  mysqld
05:04:27 PM  1002      2627    0.00    0.00    0.00    0.00    0.00    23  mysqld

```

