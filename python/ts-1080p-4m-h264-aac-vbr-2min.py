#!/usr/bin/env python3
# _*_ coding:utf-8 _*_

import subprocess as sp
import os
import logging

logging.basicConfig(filename='info.log', level=logging.WARNING)
# logging.basicConfig(filename='tcTS.log', level=logging.INFO)


def transcode(filepath, outputdir, tlime):
    command = ["ffmpeg", "-y", "-i", filepath,
               "-ss", "00:00:00",
               "-loglevel",  "error",
               "-metadata", "service_name='Push Media'",
               "-metadata", "service_provider='Push Media'",
               "-c:v", "h264",
               #"-profile:v", "high", "-level:v", "4.0",
               #"-refs", "4", "-g", "50", "-bf", "0",
               #"-refs", "4", "-bf", "1",
               #"-keyint_min", "50", "-g", "50", "-sc_threshold", "0",
               #"-flags", "+cgop",
               #"-x264-params", "nal-hrd=cbr",
               #"-b:v", "4M", "-minrate", "4M", "-maxrate", "5M", "-bufsize", "2M",
               #"-muxrate", "6M",
               "-b:v", "4M",
               "-preset", "ultrafast", "-tune", "animation",
               "-s", "1920x1080",
               "-r", "25",
               "-aspect", "16:9",
               "-c:a", "aac",
               "-b:a", "128K", "-ar", "48000",
               "-t", "00:02:00",
               outputdir + ".ts"
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
    with open('list', 'r') as f:
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
            outputdir = os.path.join(os.path.abspath('.'), 'ctest', outputdir)
            # ===输出不在当前目录===
            #output_basedir = '/home/pm/transcode'
            #outputdir = os.path.join(output_basedir, 'transcode', outputdir)
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
            transcode(filepath, outputdir, tlime)
            line = f.readline()

if __name__ == '__main__':
    main()
