#!/bin/sh

COMPONENT=TouchSQL
VERSION=1.0.6
TAG="${COMPONENT}_${VERSION}_Release"
REPO="https://jwight@touchcode.googlecode.com/hg/"
TEMP=`mktemp -d /tmp/XXXXXXX`
#GOOGLECODEPASSWORD=

echo "#### Tagging"
hg tag -m "Tagged ${COMPONENT} as ${TAG} for release" "${TAG}" || exit $?
hg push || exit $?

echo "#### Exporting Tag"
hg archive -t "tbz2" -I "${COMPONENT}/*" -r "${TAG}" "${TEMP}/${TAG}.tar.bz2" || exit $?

echo "#### Uploading tarball"
googlecode_upload.py -s "${COMPONENT} Release" -p touchcode -u "jwight" -w "${GOOGLECODEPASSWORD}" "${TEMP}/${TAG}.tar.bz2"

open "${TEMP}"


