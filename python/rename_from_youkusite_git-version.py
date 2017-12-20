#!/usr/bin/env python3

# -*- coding: utf-8 -*-

import os
import random
import json
from urllib.request import urlopen
# import urllib.request

basedir = "/Users/vivitam/git/rs/python/renametest1"
# 定义一个列表用来存储原ID，原完整路径，原扩展名
videoidAndPath = []

# 把原ID，原完整路径，原扩展名写入videoidAndPath
for firstdir, fulldir, files in os.walk(basedir):
    for filename in files:
        fullpath = os.path.join(basedir, firstdir, filename)
        filename = (os.path.splitext(filename))
        videoname = filename[0]
        suffixname = filename[1]
        videoidAndPath.append(videoname)
        videoidAndPath.append(fullpath)
        videoidAndPath.append(suffixname)

# 定义url里面用到的client_id
client_id_list = [
    '9dd9e979d8',
    '769fb7d9e',
    'eb056ac45',
    '2e1af4ff',
    'd2e7677ce',
    '11e6648a',
    '5722cb242',
    '8f1ab98d8',
    '4193bebe0'
]
# 随机使用clinet_id
client_id = random.choice(client_id_list)


# 提取原始视频id和完整路径
# 组合新的路径，并且修改视频名称

#初始化videoidAndPath
a = 0 #id
b = 1 #路径
c = 2 #扩展名
while b < len(videoidAndPath):
    video_id = videoidAndPath[a]
    api_url = 'https://api.youku.com/videos/show.json?client_id=%s&video_id=%s'
    api_url = (api_url % (client_id, video_id))
    html = urlopen(api_url).read()
    # 解析json
    content = json.loads(html)
    if 'title' in content:
        # 获取视频id对应的视频名称
        title = content['title']
        new_name = title + videoidAndPath[c]
        # 从源视频完整路径提取dirname
        new_path = os.path.dirname(videoidAndPath[b])
        # 组合新的视频完整路径
        new_full_path = os.path.join(new_path, new_name)
        # 修改视频名称
        os.renames(videoidAndPath[b], new_full_path)
    # 初始化下一组videoidAndPath数据
    a += 3
    b += 3
    c += 3
