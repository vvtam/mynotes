#Updating
#Development of FFmpeg is active and an occasional update can give you new features and bug fixes. First, remove the old files and then update the dependencies:

rm -rf ~/ffmpeg_build ~/bin/{ffmpeg,ffprobe,ffserver,lame,vsyasm,x264,x265,yasm,ytasm}
# yum install autoconf automake cmake gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel

#Update Yasm
cd ~/ffmpeg_sources/yasm
make distclean
git pull
./configure, make, and make install as shown in the Install yasm section.

Update x264

cd ~/ffmpeg_sources/x264
make distclean
git pull
Then run ./configure, make, and make install as shown in the Install x264 section.

Update x265

cd ~/ffmpeg_sources/x265
rm -rf ~/ffmpeg_sources/x265/build/linux/*
hg update
cd ~/ffmpeg_sources/x265/build/linux
Then run cmake, make, and make install as shown in the Install x265 section.

Update libfdk_aac

cd ~/ffmpeg_sources/fdk_aac
make distclean
git pull
Then run ./configure, make, and make install as shown in the Install libfdk_aac section.

Update libvpx

cd ~/ffmpeg_sources/libvpx
make clean
git pull
Then run ./configure, make, and make install as shown in the Install libvpx section.

Update FFmpeg

cd ~/ffmpeg_sources/ffmpeg
make distclean
git pull
Then run ./configure, make, and make install as shown in the Install FFmpeg section.