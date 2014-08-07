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
    ../scripts/convertOne.sh
    cd ..
done
