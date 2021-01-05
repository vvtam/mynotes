## CURL

`curl -m 10 -o /dev/null -s -w %{http_code}:%{time_connect}:%{time_starttransfer}:%{time_total} "http://IP:8080/XXX"`

```
 -s, --silent        Silent mode
 -w, --write-out <format> Use output FORMAT after completion
 -m, --max-time <seconds> Maximum time allowed for the transfer
 -o, --output <file> Write to file instead of stdout
 -I, --head          Show document info only
```

