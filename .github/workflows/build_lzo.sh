#! /usr/bin/env bash
## vim:set ts=4 sw=4 et:
## Copyright (C) Markus Franz Xaver Johannes Oberhumer
set -e; set -o pipefail

#***********************************************************************
#
#***********************************************************************

if ! test -d lzo-2.10; then true;
    curl -O http://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz
    tar -xzf lzo-2.10.tar.gz
fi
cd lzo-2.10

mkdir -p build/release
cd build/release

# note that "gcc" can be a symlink to "clang"
CC=gcc CXX=g++ cmake ../.. -DCMAKE_VERBOSE_MAKEFILE=ON
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
