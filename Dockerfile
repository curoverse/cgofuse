FROM \
    karalabe/xgo-latest

MAINTAINER \
    Bill Zissimopoulos <billziss at navimatics.com>

# add 32-bit and 64-bit architectures and install 7zip
RUN \
    dpkg --add-architecture i386 && \
    dpkg --add-architecture amd64 && \
    apt-get update && \
    apt-get install -y --no-install-recommends p7zip-full && \
    apt-get clean

# install OSXFUSE
RUN \
    wget -q -O osxfuse.dmg \
        http://sourceforge.net/projects/osxfuse/files/osxfuse-2.8.3/osxfuse-2.8.3.dmg/download && \
    echo 282330214382e853e968fe27b5075436c3444a8e osxfuse.dmg | sha1sum -c - && \
    7z e osxfuse.dmg 0.hfs && \
    7z e 0.hfs "FUSE for OS X/Install OSXFUSE 2.8.pkg" && \
    7z e "Install OSXFUSE 2.8.pkg" 10.9/OSXFUSECore.pkg/Payload && \
    7z e Payload && \
    7z x Payload~ -o/tmp && \
    cp -R /tmp/usr/local/include/osxfuse /usr/local/include && \
    cp /tmp/usr/local/lib/libosxfuse_i64.2.dylib /usr/local/lib/libosxfuse.dylib && \
    rm -rfv osxfuse.dmg 0.hfs Install*.pkg Payload*

# install LIBFUSE
RUN \
    apt-get install -y --no-install-recommends libfuse-dev:i386 && \
    apt-get install -y --no-install-recommends libfuse-dev:amd64 && \
    apt-get download libfuse-dev:i386 && \
    dpkg -x libfuse-dev*i386*.deb / && \
    apt-get clean

# install WinFsp-FUSE
RUN \
    wget -q -O winfsp.zip \
        https://github.com/billziss-gh/winfsp/archive/release/1.2.zip && \
    echo 2af2d7897d10ca67f20a09f053f5d46a6465f77a winfsp.zip | sha1sum -c - && \
    7z e winfsp.zip 'winfsp-release-1.2/inc/fuse/*' -o/usr/local/include/winfsp && \
    rm -v winfsp.zip

ENV \
    OSXCROSS_NO_INCLUDE_PATH_WARNINGS 1
