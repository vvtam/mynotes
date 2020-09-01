```
for PACKAGE in $(rpm -qa | grep kernel); do 
echo "$PACKAGE was install on \
$(date -d @$(rpm -q --qf "%{INSTALLTIME}\n" $PACKAGE))"
done
```

