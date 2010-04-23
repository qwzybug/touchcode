#!/bin/sh

COMPONENTS=( TouchXML TouchJSON TouchSQL TouchRSS )
VERSION=1.0.8

REPO="https://jwight@touchcode.googlecode.com/hg/"
#GOOGLECODEPASSWORD=

TEMP=`mktemp -d /tmp/XXXXXXX`
cd "$TEMP"

echo "#### Clone fresh repo"
hg clone -q https://touchcode.googlecode.com/hg/ touchcode
cd "$TEMP/touchcode"

for COMPONENT in ${COMPONENTS[@]}
do
	echo "#### $COMPONENT"

	TAG="${COMPONENT}_${VERSION}_Release"

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

done

open "${TEMP}"
