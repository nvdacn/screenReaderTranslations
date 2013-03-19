#!/bin/bash
set -u
source checkProgs.sh
source lock.sh

reset() {
    echo "Resetting to a clean state."
    git reset --hard HEAD
}

grabLock

git svn rebase

# ensure that we are in the scripts dir.
absPath=`readlink -f -n $0`
absPath=`dirname $absPath`
pushd ${absPath}/../ >/dev/null 2>&1

for lang in ${convertLangs[*]}; do
    echo "processing $lang"
    cd $lang
    encoding=`file *.t2t  | grep -viP "utf-8|empty|ascii"`
    if [ "$encoding" != "" ]; then
        python ../scripts/addresses.py $lang "File encoding problem" "Please save the following as unicode UTF-8: $encoding"
    else
        python ../scripts/stats.py
        $PYTHON27 ../scripts/keyCommandsDoc.py

        # process each t2t file individually to make it easier to spot errors in output.
        ls -1 *.t2t | while read file; do
            echo processing $file
            txt2tags -q $file
        done

        lastRev=`ls -1 ug-diffs/ | tail -n 1`
        diff  --unchanged-line-format='' --old-line-format='en %L' --new-line-format="$lang %L" \
        ug-diffs/$lastRev/ug-stats.txt  ug-stats.txt |
        sed -e "s/$lang $//g" -e "s/^en $//g" | sort -V -s -k 2,2 |
        sed '/^\s*$/d' >ug-stats-diff.txt
        mfiles=`git status -s -uno | grep -i ".html$" | awk '{printf(" %s", $2)}'`
        mstats=`git status -s -uno | grep -i "ug\-stats\-diff.txt$" | awk '{printf(" %s", $2)}'`

        if [ "$mfiles" != "" ]; then git add $mfiles; fi
        if [ "$mstats" != "" ]; then git add $mstats ug-stats.txt; fi
        if [ "$mfiles" != "$mstats" ]; then
            msg="${lang}: updated $mfiles $mstats from t2t."
            git commit -q -m "$msg"
            ../scripts/commit.sh
        fi
    fi
    cd ..
done
