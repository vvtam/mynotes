`tar --use-compress-program=pigz -cf file.tar.gz file1 file2`

`tar -cf file1 file2 | pigz > file.tar.gz`