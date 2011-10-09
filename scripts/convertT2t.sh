#!/bin/bash
# MMH, 30 Sep, 2010.
#
# Convert our t2t files to html.

PYTHON27=`which python2.7`

if [ "$PYTHON27" == "" ]; then
    echo "could not locate python 2.7, can not continue."
    exit
fi

git svn rebase

# ensure that we are in the scripts dir.
absPath=`readlink -f -n $0`
absPath=`dirname $absPath`
pushd ${absPath}/../ >/dev/null 2>&1

langs=(ar de fi it ja nl pl ta tr)
for lang in ${langs[*]}; do
    echo "processing $lang"
    cd $lang
    python ../scripts/stats.py
    $PYTHON27 ../scripts/generate.py

    lastRev=`ls -1 ug-diffs/ | tail -n 1`
    diff  --unchanged-line-format='' --old-line-format='en %L' --new-line-format="$lang %L" \
    ug-diffs/$lastRev/ug-stats.txt  ug-stats.txt |
    sed -e "s/$lang $//g" -e "s/^en $//g" >ug-stats-diff.txt
    mfiles=`git status -s -uno | grep -i ".html$" | awk '{printf(" %s", $2)}'`
    mstats=`git status -s -uno | grep -i "ug\-stats\-diff.txt$" | awk '{printf(" %s", $2)}'`

    if [ "$mfiles" != "" ]; then git add $mfiles; fi
    if [ "$mstats" != "" ]; then git add $mstats ug-stats.txt; fi
    if [ "$mfiles" != "$mfiles" ]; then
        msg="${lang}: updated $mfiles $mstats from t2t."
        git commit -q -m "$msg"
        ../scripts/commit.sh
    fi
    cd ..
done
