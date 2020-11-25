# Bourne Shell Builtins

##  : (a colon)

`: [参数]`

什么也不干，返回0

```
$ :
$ echo $?
0

: > xx 相当于 cat /dev/null > xx
: ${HOSTNAME?} ${USER?} ${MAIL?} 检查环境变量是否设置
```

## . (a period)

`. filename [参数]`

```
. xxx 相当于 source xxx
./xxx 当前目录，可执行
../xxx 上层目录
```

## break

Exit from a `for`, `while`, `until`, or `select` loop. If n is supplied, the nth enclosing loop is exited. n must be greater than or equal to 1. The return status is zero unless n is not greater than or equal to 1.

## cd

`cd [-L|[-P [-e]] [-@] [directory]]`

```
cd
cd -
cd ~user
```

联想

`popd pushd dirs`

## continue

`continue [n]`

Resume the next iteration of an enclosing `for`, `while`, `until`, or `select` loop. If n is supplied, the execution of the nth enclosing loop is resumed. n must be greater than or equal to 1. The return status is zero unless n is not greater than or equal to 1.

## eval

`eval [参数]`

The arguments are concatenated together into a single command, which is then read and executed, and its exit status returned as the exit status of `eval`. If there are no arguments or only empty arguments, the return status is zero.

```
$ a=10
$ b=a
$ eval echo \$$b
10
$ echo \$$b
$a

eval 执行复杂Pipeline
```

## exec

```
exec [-cl] [-a name] [command [arguments]]
```

If command is supplied, it replaces the shell without creating a new process

不启动新shell，用要执行的命令替换当前shell 进程，然后退出

```
$ exec ls
file1 file2 file3

Connection closing...Socket close.

Connection closed by foreign host.
```

```
exec命令来对文件描述符操作的时候，就不会替换shell，而且操作完成后，还会继续执行接下来的命令。
exec 3<&0
```

## exit

```
exit [n]
```

Exit the shell, returning a status of n to the shell’s parent. If n is omitted, the exit status is that of the last command executed. Any trap on `EXIT` is executed before the shell terminates.

## export

```
export [-fn] [-p] [name[=value]]
```

Mark each name to be passed to child processes in the environment. If the -f option is supplied, the names refer to shell functions; otherwise the names refer to shell variables. The -n option means to no longer mark each name for export. If no names are supplied, or if the -p option is given, a list of names of all exported variables is displayed. The -p option displays output in a form that may be reused as input. If a variable name is followed by =value, the value of the variable is set to value.

The return status is zero unless an invalid option is supplied, one of the names is not a valid shell variable name, or -f is supplied with a name that is not a shell function.

## getopts

```
getopts optstring name [args]
```

`getopts` is used by shell scripts to parse positional parameters. optstring contains the option characters to be recognized; if a character is followed by a colon, the option is expected to have an argument, which should be separated from it by whitespace. The colon (‘:’) and question mark (‘?’) may not be used as option characters. Each time it is invoked, `getopts` places the next option in the shell variable name, initializing name if it does not exist, and the index of the next argument to be processed into the variable `OPTIND`. `OPTIND` is initialized to 1 each time the shell or a shell script is invoked. When an option requires an argument, `getopts` places that argument into the variable `OPTARG`. The shell does not reset `OPTIND` automatically; it must be manually reset between multiple calls to `getopts` within the same shell invocation if a new set of parameters is to be used.

When the end of options is encountered, `getopts` exits with a return value greater than zero. `OPTIND` is set to the index of the first non-option argument, and name is set to ‘?’.

`getopts` normally parses the positional parameters, but if more arguments are given in args, `getopts` parses those instead.

`getopts` can report errors in two ways. If the first character of optstring is a colon, silent error reporting is used. In normal operation, diagnostic messages are printed when invalid options or missing option arguments are encountered. If the variable `OPTERR` is set to 0, no error messages will be displayed, even if the first character of `optstring` is not a colon.

If an invalid option is seen, `getopts` places ‘?’ into name and, if not silent, prints an error message and unsets `OPTARG`. If `getopts` is silent, the option character found is placed in `OPTARG` and no diagnostic message is printed.

If a required argument is not found, and `getopts` is not silent, a question mark (‘?’) is placed in name, `OPTARG` is unset, and a diagnostic message is printed. If `getopts` is silent, then a colon (‘:’) is placed in name and `OPTARG` is set to the option character found.

## hash

```
hash [-r] [-p filename] [-dt] [name]
```

## pwd

```
pwd [-LP]
```

Print the absolute pathname of the current working directory. If the -P option is supplied, the pathname printed will not contain symbolic links. If the -L option is supplied, the pathname printed may contain symbolic links. The return status is zero unless an error is encountered while determining the name of the current directory or an invalid option is supplied.

## readonly
```
readonly [-aAf] [-p] [name[=value]] …
```

    Mark shell variables as unchangeable.
    
    Mark each NAME as read-only; the values of these NAMEs may not be
    changed by subsequent assignment.  If VALUE is supplied, assign VALUE
    before marking as read-only.
    
    Options:
      -a	refer to indexed array variables
      -A	refer to associative array variables
      -f	refer to shell functions
      -p	display a list of all readonly variables or functions,
    		depending on whether or not the -f option is given
    
    An argument of `--' disables further option processing.
    
    Exit Status:
    Returns success unless an invalid option is given or NAME is invalid.
## return

```
return [n]
```

## shift

```
shift [n]
```

左移参数n位

Shift the positional parameters to the left by n. The positional parameters from n+1 … `$#` are renamed to `$1` … `$#`-n. Parameters represented by the numbers `$#` to `$#`-n+1 are unset. n must be a non-negative number less than or equal to `$#`. If n is zero or greater than `$#`, the positional parameters are not changed. If n is not supplied, it is assumed to be 1. The return status is zero unless n is greater than `$#` or less than zero, non-zero otherwise.

## test

## times

```
times
```

Print out the user and system times used by the shell and its children. The return status is zero.