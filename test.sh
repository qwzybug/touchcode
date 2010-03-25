#!/bin/sh

function quit {
#$cat $TEMP
echo "`basename "$FILE"` failed. [S]kip, [O]pen or [F]ail?"
read C
if [[ "$C" = O* ]]; then
	open "$FILE"
	exit
fi
if [[ "$C" = F* ]]; then
	exit
fi
}

FILES=`mdfind 'kMDItemKind = "Xcode Project File"' -onlyin .`
for FILE in $FILES
do
	echo "#############################################################"
	echo `basename "$FILE"`

	TEMP=`mktemp /tmp/XXXXXXXXXX`

	pushd `dirname "$FILE"` &> /dev/null
	xcodebuild -project `basename "$FILE"` -sdk iphonesimulator3.2 &> $TEMP || xcodebuild -project `basename "$FILE"` -sdk macosx10.6 &> $TEMP || quit
	popd
done


