#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

## apps that we need.

BZR=`which bzr`
DIFF=`which diff`
WDIFF=`which wdiff`

if [ "$BZR" == "" ]; then
echo "bzr not installed."
exit
elif [ "$WDIFF" == "" ]; then
echo "wdiff not installed."
exit
elif [ "$DIFF" == "" ]; then
echo "diff not installed."
exit
fi

## convert relative to absolute paths
## store in global var $absPath

function getAbsPath() {
absPath=`readlink -f -n $1`
}



## function that does the work.

function findRevs() {

## use the file at the given startRev as a starting point.
targetFile=/tmp/tmpfile.t2t
$BZR update -r $startRev >/dev/null 2>&1
if [ ! -e $origFile ]; then
echo "could not find $origFile"
exit
fi

cp $origFile $targetFile

echo "checking for updates to $origFile, starting at $startRev"

i=$(($startRev+1))
stop=$(($endRev+1))
while [ "$i" != "$stop" ]; do
echo -n "."
$BZR update -r $i >/dev/null 2>&1
$DIFF -q $targetFile $origFile >/dev/null  2>&1
status=$?
if [ "$status" != "0" ]; then
echo -e "\nrev$i: diffrences found."
getAbsPath ../../../../${DIFFSDIR}/$i
rel=$absPath
if [ "$newRevs" == ""]; then
newRevs="$i"
else
newRevs="$newRevs $i"
fi

if [ "$rel" == "" ]; then
echo "rel is empty, cant continue."
exit
fi

mkdir $rel
$DIFF -F "[=|+]" -u $targetFile $origFile >${rel}/diff.txt
$DIFF -F "[=|+]" -u $targetFile $origFile | 
$WDIFF -w '-{' -x '}-' -y '+{' -z '}+' -d |
sed \
-e 's/-{/\n-{/g' -e 's/}-/}-\n/g' \
-e 's/+{/\n+{/g' -e 's/}+/}+\n/g' >${rel}/wdiff.txt
$BZR log -r $i >${rel}/log.txt
cp $origFile ${rel}/
cp $origFile $targetFile
git add $rel
fi
i=$(($i+1))
done
echo -e "\nall done, checked for revision diffrences upto and including $endRev"
rm $targetFile
}

## config




## make sure we have the latest repo from assembla.
git svn rebase

## go to relative dir that has bzr code:


getAbsPath code/user_docs/en/
pushd $absPath 2>&1 >/dev/null

#echo "my current path is $PWD"
bzr pull >/dev/null 2>&1 # http://bzr.nvaccess.org/nvda/main
endRev=`bzr log | grep revno | head -n 1 | awk '{print $2}'`
if [ "$endRev" == "" ]; then
echo "could not find end revision, quitting."
exit
fi

function helper() {
newRevs=""
startRev=`ls -1 ../../../../$DIFFSDIR/ | tail -n 1`
echo "my startRev is: $startRev"
findRevs
count=`git status 2>/dev/null | grep $DIFFSDIR | wc -l`
count=$(($count/4))
git commit -m "$count new revision(s) in $DIFFSDIR: ($newrevs)"
}

origFile=changes.t2t
DIFFSDIR=ch-diffs
helper

origFile=userGuide.t2t
DIFFSDIR=ug-diffs
helper


popd >/dev/null

./commit.sh

