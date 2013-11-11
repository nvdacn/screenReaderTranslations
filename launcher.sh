#!/usr/bin/env bash
exitCode=0

#ls */settings | while read file; do
ls -1 ar/settings | while read file; do
    lang=$(dirname $file)
    echo "processing $lang"
    cd $lang
    ../scripts/checkEncoding.sh && make -f ../scripts/makefile convert
    echo "exit code $?"
    #exitCode=$(($exitCode+$?))
    cd ..
done
exit $exitCode
