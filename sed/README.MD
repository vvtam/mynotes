By default, *sed* processes input line by line

## s command

`s/REGEXP/REPLACEMENT/FLAGS`

```
s stands for substitute command
/ is an idiomatic delimiter character to separate various portions of the command
REGEXP stands for regular expression
REPLACEMENT specifies the replacement string
FLAGS are options to change default behavior of the command
```

## y command

```
$ echo 'goal new user sit eat dinner' | sed 'y/aeiou/AEIOU/'
gOAl nEw UsEr sIt EAt dInnEr
```

## In-place file editing

```
sed -i 's/blue/green/' colors.txt
sed -i.bkp 's/bad/good/' f1.txt f2.txt
sed -i'bkp.*' 's/green/yellow/' colors.txt
sed -i'backups/*' 's/good/nice/' f1.txt f2.txt
```

## Conditional execution

```
$ # change commas to hyphens only if the input line contains '2'
$ # space between the filter and command is optional
$ printf '1,2,3,4\na,b,c,d\n' | sed '/2/ s/,/-/g'
1-2-3-4
a,b,c,d
```

```
$ # change commas to hyphens if the input line does NOT contain '2'
$ # space around ! is optional
$ printf '1,2,3,4\na,b,c,d\n' | sed '/2/! s/,/-/g'
1,2,3,4
a-b-c-d
```

## Delete command

```
$ # same as: grep -v 'at'
$ printf 'sea\neat\ndrop\n' | sed '/at/d'
sea
drop
```

## Print command

```
$ sed -n '/twice/p' programming_quotes.txt
$ sed -n '/e th/p' programming_quotes.txt
$ sed -n 's/1/one/gp' programming_quotes.txt
$ sed -n '/not/ s/in/**/gp' # filter + substitution + p combination
$ printf 'sea\neat\ndrop\n' | sed -n '/at/!p' # same as: sed '/at/d'
```

## Quit commands

```
sed '/if/q' programming_quotes.txt # quits after an input line containing 'if' is found
```



## STDIN

use *-* as a source from *stdin*

tar cvf - somefileordir | (cd /dir/ && tar xvf -)

tar cf - somefileordir | tar xvf - -C /dir/

