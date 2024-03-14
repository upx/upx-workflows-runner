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

build_lzo() {
(
    mkdir -p build/$1
    cd build/$1

    # note that "gcc" can be a symlink to "clang"
    CC=gcc CXX=g++ cmake ../.. -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=$2 -DENABLE_STATIC=$3 -DENABLE_SHARED=$4
    if test -f Makefile; then true;
        # prefer "make" as old CMake versions do not have "--parallel"
        make -j
    else
        cmake --build . --parallel --config $2
    fi

    ctest -C $2

    if test -f Makefile; then true;
        # old CMake versions get confused by "--config Release" here
        DESTDIR="$PWD/Install with cmake" cmake --install .
        DESTDIR="$PWD/Install with make"  make install
    else
        DESTDIR="$PWD/Install with cmake" cmake --install . --config $2
    fi
)
}

build_lzo release-00 Release OFF OFF
build_lzo release-10 Release ON OFF
build_lzo release-01 Release OFF ON
build_lzo release-11 Release ON ON
