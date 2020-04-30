#!/bin/sh

set -e

if [ -n "$MINGW_PACKAGE_PREFIX" ]
then
    echo "This is in MSYS2/mingw-w64"
    pacman -S --needed \
    $MINGW_PACKAGE_PREFIX-ffmpeg $MINGW_PACKAGE_PREFIX-SDL2 \
    $MINGW_PACKAGE_PREFIX-meson $MINGW_PACKAGE_PREFIX-ninja
else
    echo "This is in ArchLinux"
    sudo pacman -S --needed \
    ffmpeg sdl2 \
    meson ninja
fi

PKGVER="1.13"
wget -c -O "scrcpy-v$PKGVER.tar.gz" "https://github.com/Genymobile/scrcpy/archive/v$PKGVER.tar.gz"
wget -c -O "scrcpy-server" "https://github.com/Genymobile/scrcpy/releases/download/v$PKGVER/scrcpy-server-v$PKGVER"

tar -xpf scrcpy-v$PKGVER.tar.gz
pushd scrcpy-$PKGVER

meson \
--buildtype release \
--strip \
-Db_lto=true \
-Dportable=true \
-Dprebuilt_server="../scrcpy-server" \
build

ninja -C build

popd

if [ -n "$MINGW_PACKAGE_PREFIX" ]
then
    cp "scrcpy-$PKGVER\build\app\scrcpy.exe" scrcpy-v$PKGVER.exe
else
    cp "scrcpy-$PKGVER/build/app/scrcpy" scrcpy-v$PKGVER
fi
