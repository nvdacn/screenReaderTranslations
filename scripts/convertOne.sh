#!/bin/bash
set -u

getAbsPath() {
absPath=$(readlink -f -n $1)
absPath=$(dirname $absPath)
echo $absPath
}

MYDIR=$(getAbsPath $0)

source "${MYDIR}/checkProgs.sh"
source "${MYDIR}/lock.sh"
lang=$(basename $(pwd))

encoding=`file *.t2t  | grep -vP ': +(ASCII text|UTF-8|empty)'`
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

    mfiles=`git status -s -uno . | awk '{printf(" %s", $2)}'`

    if [ "$mfiles" != "" ]; then
        git commit -q -m "${lang}: updated $mfiles" $mfiles
        ../scripts/commit.sh
    fi
fi
