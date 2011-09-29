#!/bin/bash
# MMH, 30 Sep, 2010.
#
# Convert our t2t files to html.

ICONV=`which iconv`
PYTHON27=`which python2.7`

if [ "$ICONV" == "" ]; then
    echo "unable to find iconv, can not continue."
    exit
elif [ "$PYTHON27" == "" ]; then
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
    for f in *.t2t; do
        if [ "$lang" == "ar" ]; then
            echo "Converting $f to utf8."; 
            $ICONV -f utf16 -t utf8 <${f} >tmp.t2t
            mv tmp.t2t ${f}
        fi
    done

    $PYTHON27 ../scripts/generate.py

    for f in *.t2t; do
        git checkout ${f}
    done

    python ../scripts/stats.py

    mfiles=`git status -s -uno | grep -i ".html$" | awk '{printf(" %s", $2)}'`
    mstats=`git status -s -uno | grep -i "\-stats.txt$" | awk '{printf(" %s", $2)}'`

    if [ "$mfiles" != "" ]; then
        git add $mfiles
        git add $mstats
        msg="${lang}: updated $mfiles $mstats from t2t."
        git commit -m "$msg"
        ../scripts/commit.sh
    fi
    cd ..
done
