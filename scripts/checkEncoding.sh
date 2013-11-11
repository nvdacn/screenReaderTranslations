#!/usr/bin/env bash
pattern='*.t2t'
text=$(file $pattern | grep -viP "utf-8")
count=$(file *.t2t | grep -viP "utf-8" | wc -l)
lang=$(basename $PWD)
sed -i -e "s/utf8Problems=\([0-9]*\)/utf8Problems=${count}/" settings
needToCommit=$(git status --porcelain  settings | wc -l)
if [ "$count" != "0" ]; then
    if [ "$needToCommit" != "0" ]; then
        echo -e "$lang: File(s) with an encoding problem\n\n$text" | git commit -q -F - settings
        echo "$text"
    fi
    exit 1
elif [ "$needToCommit" != "0" ]; then
    git add settings
    touch $pattern
fi
