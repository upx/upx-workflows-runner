#! /usr/bin/env bash
## vim:set ts=4 sw=4 et:
## Copyright (C) Markus Franz Xaver Johannes Oberhumer
set -e; set -o pipefail

#***********************************************************************
#
#***********************************************************************

if ! test -d .git; then true;
    git clone --branch devel --depth 1 https://github.com/upx/upx .
    test -f ./.gitmodules && git submodule update --init
fi

mkdir -p build/release
cd build/release

# note that "gcc" can be a symlink to "clang"
CC=gcc CXX=g++ cmake ../.. -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Release
if test -f Makefile; then true;
    make -j
else
    cmake --build . --parallel --config Release
fi

# TODO: skip test on macOS
##ctest

DESTDIR="$PWD/Install with cmake" cmake --install . --config Release
if test -f Makefile; then true;
    DESTDIR="$PWD/Install with make"  make install
fi
