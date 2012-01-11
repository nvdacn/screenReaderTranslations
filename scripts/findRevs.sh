#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
msg=""
helperMsg=""

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
fpath=$2
diffsDir=$3
fname=$4
newRevs=""
echo "processing $lang: $fname"
startRev=`ls -1 ${lang}/$diffsDir/ | tail -n 1`
if [ "$startRev" == "disabled" ]; then
return
fi
startRev=$(($startRev+1))
#echo "my startRev is: $startRev"
newRevs=`bzr log -r${startRev}.. $BZRDIR/$fpath/$fname | grep -P "^revno: [0-9]+$" | sort | awk '{printf("%d ", $2)}'`
echo "revs to be processed: $newRevs"
prevRev=$startRev
revCounter=0
newRevs=($newRevs)
for rev in ${newRevs[*]}; do
#echo "processing $rev"
mkdir -p $lang/$diffsDir/$rev
bzr log -r$rev $BZRDIR/$fpath/$fname > $lang/$diffsDir/$rev/log.txt
bzr cat -r$rev $BZRDIR/$fpath/$fname > $lang/$diffsDir/$rev/$fname
bzr diff -r$prevRev..$rev $BZRDIR/$fpath/$fname > $lang/$diffsDir/$rev/diff.txt
bzr diff -r$prevRev..$rev $BZRDIR/$fpath/$fname |
$WDIFF -w '-{' -x '}-' -y '+{' -z '}+' -d |
sed -e 's/-{/\n-{/g' -e 's/}-/}-\n/g' \
-e 's/+{/\n+{/g' -e 's/}+/}+\n/g' > $lang/$diffsDir/$rev/wdiff.txt
if [ "$diffsDir" == "ug-diffs" ]; then
pushd $lang/$diffsDir/$rev/ >/dev/null
python ../../../scripts/stats.py
# update ug-stats-diff at the same time
diff  --unchanged-line-format='' --old-line-format='en %L' --new-line-format="$lang %L" \
ug-stats.txt ../../ug-stats.txt |
sed -e "s/$lang $//g" -e "s/^en $//g" | sort -V -s -k 2,2 | 
sed '/^\s*$/d' >../../ug-stats-diff.txt
git add ../../ug-stats-diff.txt
popd >/dev/null
fi
git add $lang/$diffsDir/$rev
revCounter=$(($revCounter+1))
prevRev=$rev
done
if [ "$revCounter" != "0" ]; then
helperMsg="$revCounter in $diffsDir (${newRevs[*]})"
else
helperMsg=''
fi
}



## config

# make sure we have the latest repo from assembla.
git svn rebase

# go to relative dir that has bzr code:
getAbsPath ../
pushd $absPath 2>&1 >/dev/null
BZRDIR=scripts/code
pushd $BZRDIR
bzr pull
popd

declare -A twitAddr
twitAddr[ar]="@nvdauser"
twitAddr[de]="@bdorer1"
twitAddr[sk]="@pvagner"

langs=(ar de es fi fr gl it ja nl pl pt_BR pt_PT sk ta tr)
for lang in ${langs[*]}; do
    echo "processing $lang"
    findRevs $lang user_docs/en/ ch-diffs changes.t2t
    msgP1="$helperMsg"
    findRevs $lang user_docs/en/ ug-diffs userGuide.t2t
    msgP2="$helperMsg"
    # make sure the format looks nice.
    newMsg=''
    if [ "$msgP1" != '' ] && [ "$msgP2" != '' ]; then
        newMsg="$msgP1; $msgP2"
    elif [ "$msgP1" != '' ]; then
        newMsg="$msgP1"
    elif [ "$msgP2" != '' ]; then
        newMsg="$msgP2"
    fi
    if [ "$newMsg" != "" ]; then
        twidge update "${twitAddr[$lang]} $lang: new revision(s) for translation: $newMsg"
        msg="${msg}${lang}: new revision(s): ${newMsg}\n"
    fi
done

popd >/dev/null
echo -e "new revisions to be translated\n\n$msg" | git commit -F -

./commit.sh
