#! /usr/bin/env bash
## vim:set ts=4 sw=4 et:
## Copyright (C) Markus Franz Xaver Johannes Oberhumer
set -e; set -o pipefail

#***********************************************************************
#
#***********************************************************************

if ! test -d upx-devel; then true;
    git clone --branch devel --depth 1 https://github.com/upx/upx upx-devel
    (cd upx-devel && test -f ./.gitmodules && git submodule update --init)
fi
cd upx-devel

mkdir -p build/release
cd build/release

self_pack="-DUPX_CONFIG_DISABLE_SELF_PACK_TEST=OFF"
if test -d /Library; then # disable self-pack on macOS
    self_pack="-DUPX_CONFIG_DISABLE_SELF_PACK_TEST=ON"
fi

# note that "gcc" can be a symlink to "clang"
CC=gcc CXX=g++ cmake ../.. -DCMAKE_VERBOSE_MAKEFILE=ON $self_pack
if test -f Makefile; then true;
    # prefer "make" as old CMake versions do not have "--parallel"
    make -j
else
    cmake --build . --parallel --config Release
fi

ctest -C Release

if test -f Makefile; then true;
    # old CMake versions get confused by "--config Release" here
    DESTDIR="$PWD/Install with cmake" cmake --install .
    DESTDIR="$PWD/Install with make"  make install
else
    DESTDIR="$PWD/Install with cmake" cmake --install . --config Release
fi
