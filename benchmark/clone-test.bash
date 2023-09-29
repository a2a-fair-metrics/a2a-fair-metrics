#!/bin/bash
set -e
USAGE="Usage: clone-test.bash [origin] [destination]"
if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
	echo $USAGE
	exit 0
fi
if [ "$1" == "" ] || [ "$2" == "" ] ; then 
	echo $USAGE
	exit 1
fi
if [ ! -d $1 ] ; then 
	echo "Missing origin $1" 
	exit 2
fi

if [ -e $2 ] ; then 
	echo "Already exist destination $2"
        exit 3
fi

from=`basename $1`
to=`basename $2`
# Note not testing for final /
(echo $to | grep -q -E "^([0-9][0-9]*-[a-z0-9-]*)$") || (echo "Invalid test pattern $2, see https://github.com/perma-id/w3id.org/blob/master/a2a-fair-metrics/.htaccess#L8" ; exit 5)

cp -r $1 $2
if [ ! -d $2 ] ; then
	echo "Copying failed to $2"
	exit 4
fi

# Search-replace-time
find $2 -type f | xargs -L1 sed -i "s/$from/$to/g"
echo $from "->" $to
