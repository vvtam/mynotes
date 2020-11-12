# awk

## 求和

awk '{sum += $1}; END {print sum}'  abc

awk '/xyz/ {sum += $1}; END {print sum}' abc

