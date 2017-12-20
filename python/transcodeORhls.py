#!/usr/bin/env python3
# _*_ coding:utf-8 _*_

import subprocess as sp
import json
import os


def probe(filepath):
    ''' Give a json from ffprobe command line

    @filepath: The absolute (full) path of the video file, string.
    '''
    if type(filepath) != str:
        raise Exception('Gvie ffprobe a full file path of the video')

    prog = ["ffprobe",
            "-loglevel",  "quiet",
            "-print_format", "json",
            "-show_format",
            "-show_streams",
            filepath
            ]
    pipe = sp.Popen(prog, stdout=sp.PIPE, stderr=sp.STDOUT)
    out, err = pipe.communicate()

#    if pipe.returncode == 0:
#        print ("command '%s' succeeded, returned: %s" \
#               % (prog, str(out)))
#    else:
#        print ("command '%s' failed, exit-code=%d error = %s" \
#               % (prog, pipe.returncode, str(err)))

    return json.loads(out)


def transcode(filepath, resdir):
    ''' Video's duration in seconds, return a float number
    '''
    _json = probe(filepath)
    # 定义一个空的列表用来存音频视频编码
    codec = []
    # 定义转码参数
    try:
        if 'streams' in _json:
            for cc in _json['streams']:
                if 'codec_name' in cc:
                    codec.append(cc['codec_name'])

    # if everything didn't happen,
    # we got here because no single 'return' in the above happen.
    # raise Exception('I found no duration')
    # return 0
    # except OSError:
    #    print("Can't found duration")
    #    return 0

    finally:
        print(codec)
        if 'h264' in codec and 'aac' in codec:
            command = ["ffmpeg", "-y",
                       "-i", filepath,
                       "-loglevel",  "quiet",
                       "-c:a", "copy",
                       "-c:v", "copy",
                       "-f", "hls", "-hls_time", "10", "-hls_list_size", "0",
                       resdir + "/playlist.m3u8"
                       ]
            pipe = sp.Popen(command, stdout=sp.PIPE, stderr=sp.STDOUT)
            out, err = pipe.communicate()
            if pipe.returncode == 0:
                print("command '%s' succeeded, returned: %s"
                      % (command, str(out)))
            else:
                print("command '%s' failed, exit-code=%d error = %s"
                      % (command, pipe.returncode, str(err)))
        elif 'h264' in codec and 'mp3' in codec:
            command = ["ffmpeg", "-y",
                       "-i", filepath,
                       "-loglevel",  "quiet",
                       "-c:a", "copy",
                       "-c:v", "copy",
                       "-f", "hls", "-hls_time", "10", "-hls_list_size", "0",
                       resdir + "/playlist.m3u8"
                       ]
            pipe = sp.Popen(command, stdout=sp.PIPE, stderr=sp.STDOUT)
            out, err = pipe.communicate()
            if pipe.returncode == 0:
                print("command '%s' succeeded, returned: %s"
                      % (command, str(out)))
            else:
                print("command '%s' failed, exit-code=%d error = %s"
                      % (command, pipe.returncode, str(err)))


def mkdir(hlsdir):
    hlsdir = hlsdir.strip()
    hlsdir = hlsdir.rstrip("\\")

    ifExists = os.path.exists(hlsdir)

    if not ifExists:
        print(hlsdir + "dir create success")
        os.makedirs(hlsdir)
        return True
    else:
        print(hlsdir + "already exist")
        return False


f = open("videoList", 'r')
line = f.readline()

while line:
    filepath = line.strip()  # 去除行尾的"\n"
    filedir = os.path.splitext(filepath)
    outputdir = filedir[0]
    if os.path.exists(os.path.join(os.path.join(os.path.abspath('.'), 'hls'), outputdir)):
        print(os.path.join(os.path.join(os.path.abspath('.'), 'hls'), outputdir)
              + ", the dir already exist.")
    else:
        print(os.path.join(os.path.join(os.path.abspath('.'), 'hls'), outputdir)
              + ", the dir create success.")
        os.makedirs(os.path.join(os.path.join(
            os.path.abspath('.'), 'hls'), outputdir))
    resdir = os.path.join(os.path.join(os.path.abspath('.'), 'hls'), outputdir)
    resdir = resdir.strip()
    transcode(filepath, resdir)
    line = f.readline()
f.close
