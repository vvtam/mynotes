#!/bin/bash
#https://trac.ffmpeg.org/wiki/CompilationGuide/Centos

yum install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel

#In your homedir directory make a new directory to put all of the source code into:

homedirdir = 

mkdir $homedirdir/ffmpeg_sources

#Yasm
#Yasm is an assembler used by x264 and FFmpeg.

cd $homedirdir/ffmpeg_sources
git clone --depth 1 git://github.com/yasm/yasm.git
cd yasm
autoreconf -fiv
./configure --prefix="$homedir/ffmpeg_build" --bindir="$homedir/bin"
make
make install
make distclean

#libx264
#H.264 video encoder. See the H.264 Encoding Guide for more information and usage examples.
#Requires ffmpeg to be configured with --enable-gpl --enable-libx264.

cd $homedirdir/ffmpeg_sources
git clone --depth 1 git://git.videolan.org/x264
cd x264
PKG_CONFIG_PATH="$homedir/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$homedir/ffmpeg_build" --bindir="$homedir/bin" --enable-static
make
make install
make distclean

#libx265
#H.265/HEVC video encoder. See the H.265 Encoding Guide for more information and usage examples.
#Requires ffmpeg to be configured with --enable-gpl --enable-libx265.

cd $homedirdir/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd $homedirdir/ffmpeg_sources/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$homedir/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make
make install

#libfdk_aac
#AAC audio encoder.
#Requires ffmpeg to be configured with --enable-libfdk-aac (and --enable-nonfree if you also included --enable-gpl).

cd $homedirdir/ffmpeg_sources
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$homedir/ffmpeg_build" --disable-shared
make
make install
make distclean

#libmp3lame
#MP3 audio encoder.
#Requires ffmpeg to be configured with --enable-libmp3lame.

cd $homedirdir/ffmpeg_sources
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$homedir/ffmpeg_build" --bindir="$homedir/bin" --disable-shared --enable-nasm
make
make install
make distclean

#libopus
#Opus audio decoder and encoder.
#Requires ffmpeg to be configured with --enable-libopus.

cd $homedirdir/ffmpeg_sources
git clone git://git.opus-codec.org/opus.git
cd opus
autoreconf -fiv
./configure --prefix="$homedir/ffmpeg_build" --disable-shared
make
make install
make distclean

#libogg
#Ogg bitstream library. Required by libtheora and libvorbis.

cd $homedirdir/ffmpeg_sources
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix="$homedir/ffmpeg_build" --disable-shared
make
make install
make distclean

#libvorbis
#Vorbis audio encoder. Requires libogg.
#Requires ffmpeg to be configured with --enable-libvorbis.

cd $homedirdir/ffmpeg_sources
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
LDFLAGS="-L$homedir/ffmeg_build/lib" CPPFLAGS="-I$homedir/ffmpeg_build/include" ./configure --prefix="$homedir/ffmpeg_build" --with-ogg="$homedir/ffmpeg_build" --disable-shared
make
make install
make distclean

#libvpx
#VP8/VP9 video encoder.
#Requires ffmpeg to be configured with --enable-libvpx.

cd $homedirdir/ffmpeg_sources
git clone --depth 1 https://github.com/webmproject/libvpx.git
cd libvpx
./configure --prefix="$homedir/ffmpeg_build" --disable-examples
make
make install
make clean

#FFmpeg

cd $homedirdir/ffmpeg_sources
git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git
cd FFmpeg
PKG_CONFIG_PATH="$homedir/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$homedir/ffmpeg_build" --extra-cflags="-I$homedir/ffmpeg_build/include" --extra-ldflags="-L$homedir/ffmpeg_build/lib" --bindir="$homedir/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265
make
make install
make distclean
hash -r