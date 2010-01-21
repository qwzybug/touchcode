#!/bin/sh

COMPONENT=TouchXML
VERSION=1.0.7
TAG="${COMPONENT}_${VERSION}_Release"
REPO="https://jwight@touchcode.googlecode.com/hg/"
TEMP=`mktemp -d /tmp/XXXXXXX`
#GOOGLECODEPASSWORD=

cd "$TEMP"

echo "#### Clone fresh repo"
hg clone -q https://touchcode.googlecode.com/hg/ touchcode
cd "$TEMP/touchcode"

echo "#### Switching to default branch"
hg update -q -C default

echo "#### Tagging"
hg tag -q -f -m "Tagged ${COMPONENT} as ${TAG} for release" "${TAG}" || exit $?

echo "#### Exporting Tag"
hg archive -q -t "tbz2" -I "${COMPONENT}/*" -r "${TAG}" "${TEMP}/${TAG}.tar.bz2" || exit $?

echo "#### Pushing"
hg push -f || exit $?

echo "#### Uploading tarball"
googlecode_upload.py -s "${COMPONENT} Release" -p touchcode -u "jwight" -w "${GOOGLECODEPASSWORD}" "${TEMP}/${TAG}.tar.bz2"

open "${TEMP}"


