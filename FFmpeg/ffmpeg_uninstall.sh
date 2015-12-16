#!/bin/bash
#Reverting changes made by this guide

rm -rf ~/ffmpeg_build ~/ffmpeg_sources ~/bin/{ffmpeg,ffprobe,ffserver,lame,vsyasm,x264,yasm,ytasm}
yum erase autoconf automake cmake gcc gcc-c++ git libtool mercurial nasm pkgconfig zlib-devel
hash -r