
$BZR log -r $i >${rel}/log.txt
cp $tempFile $targetFile
cp $targetFile ${rel}/$origFile
#### add stats file for userGuide
if [ "$origFile" == "userGuide.t2t" ]; then
pushd $rel >/dev/null 2>&1
python ../../../scripts/stats.py

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
helperMsg="$count in $DIFFSDIR ($newRevs)"
else
helperMsg=''
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
twitAddr[ar]="@nvdauser"
twitAddr[de]="@bdorer1"
twitAddr[sk]="@pvagner"

langs=(ar de es fi fr gl it ja nl pl pt_BR sk ta tr)
for lang in ${langs[*]}; do
    echo "processing $lang"
    origFile=changes.t2t
    DIFFSDIR=ch-diffs
    helper $lang
    msgP1="$helperMsg"
    origFile=userGuide.t2t
    DIFFSDIR=ug-diffs
    helper $lang
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
