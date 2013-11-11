#!/bin/bash
lang=$1
lastRev=`ls -1 userGuide-diffs/ | tail -n 1`
diff  --unchanged-line-format='' --old-line-format='en %L' --new-line-format="$lang %L" \
userGuide-diffs/$lastRev/userGuide-stats.txt  userGuide-stats.txt |
sed -e "s/$lang $//g" -e "s/^en $//g" | sort -V -s -k 2,2 |
sed '/^\s*$/d' >userGuide-stats-diff.txt
