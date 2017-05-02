#!/usr/bin/env bash

_SELF="${0##*/}"
_HERE="${0%${SELF}}"

cachedir=$1
bin_name=$2
version=$3
os=$4
arch=$5

basefile="${bin_name}_${version}"
zipfile="${basefile}_${os}_${arch}.zip"
sumfile="${basefile}_SHA256SUMS"
sigfile="${sumfile}.sig"

baseurl="https://releases.hashicorp.com/${bin_name}/${version}"

pushd "${cachedir}"
[ -f "${zipfile}" ] || curl -Os "${baseurl}/${zipfile}"
[ -f "${sumfile}" ] || curl -Os "${baseurl}/${sumfile}"
[ -f "${sigfile}" ] || curl -Os "${baseurl}/${sigfile}"

gpg --verify "${sigfile}" "${sumfile}" || exit 1
grep "${zipfile}" "${sumfile}" | sha256sum --quiet -c || exit 1
mkdir "${bin_name}_${version}"
pushd "${bin_name}_${version}"
unzip -q "../${zipfile}" || exit 1
popd
popd
