#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
msg=""

# apps that we need.

BZR=`which bzr`
DIFF=`which diff`
WDIFF=`which wdiff`
TWIDGE=`which twidge`

if [ "$BZR" == "" ]; then
    echo "bzr not installed."
    exit
elif [ "$WDIFF" == "" ]; then
    echo "wdiff not installed."
    exit
elif [ "$DIFF" == "" ]; then
    echo "diff not installed."
    exit
elif [ "$TWIDGE" == "" ]; then
    echo "twidge not installed."
    exit
fi

# convert relative to absolute paths
# store in global var $absPath

function getAbsPath() {
absPath=`readlink -f -n $1`
}

# function that does the work.

function findRevs() {
lang=$1
# use the file at the given startRev as a starting point.
targetFile=`mktemp`
tempFile=`mktemp`

if [ ! -e $origFile ]; then
    echo "could not find $origFile"
    exit
fi
$BZR cat -r $startRev $origFile >$tempFile
cp $tempFile $targetFile

echo "checking for updates to $origFile, starting at $startRev"

i=$(($startRev+1))
stop=$(($endRev+1))
while [ "$i" != "$stop" ]; do
echo -n "."
$BZR cat -r $i $origFile >$tempFile

$DIFF -q $targetFile $tempFile >/dev/null 2>&1
status=$?
if [ "$status" != "0" ]; then
echo -e "\nrev$i: diffrences found."
getAbsPath ../../../../$lang/${DIFFSDIR}/$i
rel=$absPath
if [ "$newRevs" == "" ]; then
newRevs="$i"
else
newRevs="${newRevs}, $i"
fi

if [ "$rel" == "" ]; then
echo "rel is empty, cant continue."
exit
fi

mkdir $rel
$DIFF -F "[=|+]" -u $targetFile $tempFile >${rel}/diff.txt
$DIFF -F "[=|+]" -u $targetFile $tempFile | 
$WDIFF -w '-{' -x '}-' -y '+{' -z '}+' -d |
sed \
-e 's/-{/\n-{/g' -e 's/}-/}-\n/g' \
-e 's/+{/\n+{/g' -e 's/}+/}+\n/g' >${rel}/wdiff.txt
$BZR log -r $i >${rel}/log.txt
cp $tempFile $targetFile
cp $targetFile ${rel}/$origFile
#### add stats file for userGuide
if [ "$origFile" == "userGuide.t2t" ]; then
pushd $rel >/dev/null 2>&1
python ../../../scripts/stats.py
# update ug-stats-diff at the same time
diff  --unchanged-line-format='' --old-line-format='en %L' --new-line-format="$lang %L" \
ug-stats.txt ../../ug-stats.txt |
sed -e "s/$lang $//g" -e "s/^en $//g" | sort -V -s -k 2,2 | 
sed '/^\s*$/d' >../../ug-stats-diff.txt
git add ../../ug-stats-diff.txt
popd >/dev/null 2>&1
fi
git add $rel
fi
i=$(($i+1))
done
echo -e "\nall done, checked for revision diffrences upto and including $endRev"
rm $targetFile
}



function helper() {
lang=$1
newRevs=""
startRev=`ls -1 ../../../../${lang}/$DIFFSDIR/ | tail -n 1`
if [ "$startRev" == "disabled" ]; then
return
fi

echo "my startRev is: $startRev"
findRevs $lang
count=`git status 2>/dev/null | grep "$lang/$DIFFSDIR" | wc -l`
divisor=4
if [ "$DIFFSDIR" == "ug-diffs" ]; then divisor=5; fi
count=$(($count/$divisor))
if [ "$count" != "0" ]; then
newMsg="$lang: $count new revision(s) in $DIFFSDIR ($newRevs)"
msg="${msg}\n${newMsg}"
twidge update "${twitAddr[$lang]} ${newMsg} need translating."
fi
}


## config

# make sure we have the latest repo from assembla.
git svn rebase

# go to relative dir that has bzr code:
getAbsPath code/user_docs/en/
pushd $absPath 2>&1 >/dev/null

bzr pull >/dev/null 2>&1 # http://bzr.nvaccess.org/nvda/main
endRev=`bzr log | grep revno | head -n 1 | awk '{print $2}'`
if [ "$endRev" == "" ]; then
    echo "could not find end revision, quitting."
    exit
fi

declare -A twitAddr
twitAddr[ar]="@mesarhameed"

langs=(ar de es fi fr gl it ja nl pl pt_BR sk ta tr)
for lang in ${langs[*]}; do
    echo "processing $lang"
    origFile=changes.t2t
    DIFFSDIR=ch-diffs
    helper $lang

    origFile=userGuide.t2t
    DIFFSDIR=ug-diffs
    helper $lang
done

popd >/dev/null
echo -e "new revisions to be translated\n\n$msg" | git commit -F -

./commit.sh
