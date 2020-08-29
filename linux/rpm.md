rpm2cpio packagefile.rpm | cpio -id ,会在当前目录下创建

rpm2cpio packagefile.rpm | cpio -id  "*txt"

## rpm常用命令

rpm -qa

rpm -q name

rpm -qi name

rpm -ql name

rpm -qc name

rpm -qd name

rpm -q --changelog name

rpm -q --scripts name