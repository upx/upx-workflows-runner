#! /usr/bin/env sh
## vim:set ts=2 sw=2 et:
## Copyright (C) Markus Franz Xaver Johannes Oberhumer
set -e
DEBIAN_FRONTEND=noninteractive; export DEBIAN_FRONTEND

#***********************************************************************
#
#***********************************************************************

if test -f /etc/alpine-release; then true;
  apk update && apk upgrade && apk add bash git
elif test -f /etc/chimera-release; then true;
  apk update && apk upgrade && apk add bash git
elif test -f /etc/redhat-release && test -f /usr/bin/dnf; then true;
  dnf update -y && dnf install -y bash git
elif test -f /etc/redhat-release && test -f /usr/bin/microdnf; then true;
  microdnf update -y && microdnf install -y bash git
elif test -f /etc/debian_version; then true;
  apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends bash ca-certificates git
fi

git config --global core.autocrlf false
git config --global --add safe.directory '*'

##git clone --branch "$GITHUB_REF_NAME" --depth 1 "$GITHUB_SERVER_URL/$GITHUB_REPOSITORY" ../Self
