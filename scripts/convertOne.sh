#!/bin/bash
set -u
source checkProgs.sh
source lock.sh

encoding=`file *.t2t  | grep -viP "utf-8|empty|ascii"`
if [ "$encoding" != "" ]; then
    python ../scripts/addresses.py $lang "File encoding problem" "Please save the following as unicode UTF-8: $encoding"
else
    $PYTHON27 ../scripts/keyCommandsDoc.py

    # process each t2t file individually to make it easier to spot errors in output.
    ls -1 *.t2t | while read file; do
        echo processing $file
        txt2tags -q $file
    done

    ../scripts/rebuildStats.sh

    mfiles=`git status -s -uno | grep -i ".html$" | awk '{printf(" %s", $2)}'`
    mstats=`git status -s -uno . | grep -i "structuredifferences.txt" | awk '{printf(" %s", $2)}'`

    if [ "$mfiles" != "" ]; then git add $mfiles; fi
    if [ "$mfiles" != "$mstats" ]; then
        msg="${lang}: updated $mfiles $mstats from t2t."
        git commit -q -m "$msg"
        ../scripts/commit.sh
    fi
fi

