#! /usr/bin/env bash
## vim:set ts=2 sw=2 et:
## Copyright (C) Markus Franz Xaver Johannes Oberhumer
set -e; set -o pipefail
export DEBIAN_FRONTEND=noninteractive

git config --global core.autocrlf false

#***********************************************************************
# install packages to match GitHub runners
#***********************************************************************

if test -n "$CONTAINER"; then true;
if test -f /etc/alpine-release; then true;
  apk update && apk upgrade && apk add bzip2 cmake coreutils curl g++ gzip make python3 rsync tar unzip xz zip
elif test -f /etc/chimera-release; then true;
  apk update && apk upgrade && apk add bsdtar bzip2 clang cmake curl gmake gtar python rsync unzip xz zip
  ln -s -v ../../bin/clang++ /usr/local/bin/g++
  ln -s -v ../../bin/clang /usr/local/bin/gcc
  ln -s -v ../../bin/gmake /usr/local/bin/make
  ln -s -v ../../bin/gtar /usr/local/bin/tar
elif test -f /etc/redhat-release && test -f /usr/bin/microdnf; then true;
  microdnf install -y bzip2 cmake gcc-c++ make python3 rsync tar unzip xz zip
elif test -f /etc/redhat-release && test -f /usr/bin/dnf; then true;
  dnf      install -y bzip2 cmake gcc-c++ make python3 rsync tar unzip xz zip
elif test -f /etc/debian_version; then true;
  apt-get update && apt-get upgrade -y
  apt-get install -y --no-install-recommends bzip2 cmake curl g++ make python3 rsync unzip xz-utils zip
fi
fi # CONTAINER

# TODO: manually install cmake (ubi7)

uname -a; pwd; id; umask
env | LC_ALL=C sort

# required for all images:
bash --version
bzip2 --version
cmake --version
curl --version
g++ --version
gcc --version
git --version
gzip --version
make --version
python3 --version
# TODO: check which tar is installed (macOS seems to use bsdtar)
tar --version
unzip -v
xz --version

# TODO: choco install rsync (missing on GitHub windows-2019 and windows-2022)
rsync --version || true
# TODO: choco install zip (missing on GitHub windows-2019 and windows-2022)
zip --version || true
