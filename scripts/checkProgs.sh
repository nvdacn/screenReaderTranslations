#!/usr/bin/env bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Checking for the existance of needed programs (sorted)

BZR=`which bzr`
CURL=`which curl`
DIFF=`which diff`
#ELINKS=`which elinks`
MSGMERGE=`which msgmerge`
POCOUNT=`which pocount`
PYTHON27=`which python2.7`
TWIDGE=`which twidge`
WDIFF=`which wdiff`
XGETTEXT=`which xgettext`

if [ "$BZR" == "" ]; then
    echo "bzr not installed."
    exit 1
elif [ "$CURL" == "" ]; then
    echo "Can't find curl."
    exit 1
elif [ "$DIFF" == "" ]; then
    echo "diff not installed."
    exit 1
#elif [ "$ELINKS" == "" ]; then
#    echo "Can't find elinks."
#    exit 1
elif [ "$MSGMERGE" == "" ]; then
    echo "Can't find msgmerge."
    exit 1
elif [ "$POCOUNT" == "" ]; then
    echo "Can't find pocount."
    exit 1
elif [ "$PYTHON27" == "" ]; then
    echo "could not locate python 2.7, can not continue."
    exit 1
#elif [ "$TWIDGE" == "" ]; then
#    echo "twidge not installed."
#    exit 1
elif [ "$WDIFF" == "" ]; then
    echo "wdiff not installed."
    exit 1
elif [ "$XGETTEXT" == "" ]; then
    echo "Can't find xgettext."
    exit 1
fi

source systemData.sh

