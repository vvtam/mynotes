#!/usr/bin/env python3
# _*_ coding:utf-8 _*_

import subprocess as sp
import os
import logging

logging.basicConfig(filename='transcode.log', level=logging.WARNING) # logging.basicConfig(filename='tcTS.log', level=logging.INFO)


def transcode(filepath, outputdir):
    command = ["ffmpeg", "-y", "-i", filepath,
               "-loglevel",  "error",
               "-c:v", "libx265",
               #"-profile:v", "high", "-level:v", "4.1",
               #"-x264-params", "nal-hrd=cbr",
               #"-b:v", "4M", "-minrate", "4M", "-maxrate", "4M", "-bufsize", "1M",
               "-b:v", "4M",
               "-s", "1920x1080",
               "-r", "25",
               "-c:a", "aac",
               "-b:a", "128K", "-ar", "48000",
               outputdir + ".mp4"
               ]
    pipe = sp.Popen(command, stdout=sp.PIPE, stderr=sp.STDOUT)
    out, err = pipe.communicate()
    if pipe.returncode == 0:
        logging.info("command '%s' succeeded, returned: %s"
                     % (command, str(out)))
    else:
        logging.error("command '%s' failed, exit-code=%d error = %s"
                      % (command, pipe.returncode, str(err)))


def main():
    # 打开视频列表文件
    with open('list3', 'r') as f:
        line = f.readline()
        # 逐行读取文件，并新建输出路径
        while line:
            # 输出入文件路径
            filepath = line.strip()  # 去除行尾的"\n"
            # 去除文件扩展名，获得一个list
            filedir = os.path.splitext(filepath)
            # 去除文件扩展名后的路径作为输出的路径
            outputdir = filedir[0]
            # 文件扩展名
            # filesuffix = filedir[1]
            # raise SystemExit('Debug and Exit!') #调试
            # 输出在当前目录
            #outputdir = os.path.join(os.path.abspath('.'), '4m1080pmp4', outputdir)
            # ===输出不在当前目录===
            output_basedir = '/data/'
            outputdir = os.path.join(output_basedir, 'transcode', outputdir)
            # ===输出不在当前目录===
            # 标准化路径名，合并多余的分隔符和上层引
            outputdir = os.path.normpath(outputdir)
            # 替换空格
            #outputdir = outputdir.replace(" ", "_")
            output_basedir = os.path.dirname(outputdir)
            if os.path.exists(output_basedir):
                logging.info(output_basedir + ", the dir already exist.")
            else:
                logging.info(output_basedir + ", the dir create success.")
                os.makedirs(output_basedir)
            logging.warning(filepath)  # 记录进度
            transcode(filepath, outputdir)
            line = f.readline()

if __name__ == '__main__':
    main()
