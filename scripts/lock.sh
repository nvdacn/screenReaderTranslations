#!/usr/bin/env bash

LOCKDIR=/tmp/NVDA_Tran.lock

cleanup() {
    echo "cleaning up lock"
    rm -rf $LOCKDIR
    trap '' EXIT
}

grabLock () {
    if ! mkdir $LOCKDIR >/dev/null 2>&1;  then
        pid=$(cat $LOCKDIR/pid)
        echo "could not grab $LOCKDIR, $pid got it."
        running=$(ps -p $pid -o pid= -o comm= | wc -l)
        if [ "$running" == "0" ]; then
            echo "it looks like the lock is stail., no pid $pid was found."
            exit 1
        fi
        exit 0
    fi
    trap "cleanup exit 0;" EXIT
    trap "reset; cleanup; exit 1" INT TERM 
    echo $$ >$LOCKDIR/pid
}

