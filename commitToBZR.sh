#!/bin/bash
langs=(ar an cs da de el es gl fi fr hu hr is it ja ko nb_NO ne nl pl pt_BR pt_PT ru sk sl ta tr uk zh_CN zh_HK zh_TW)
langs=(ga)
for lang in ${langs[*]}; do
echo processing $lang
# check if the directory has been modified since last commit.
#svn log -r '{2012-07-30}':head -q | grep -viP "\-\-\-\-|commitbot|mhameed"

# check po file compiles.
cd $lang
msgfmt -c nvda.po
code=$?
cd ..
if [ "$code" == "0" ]; then

scons -c -Q -f scripts/sconstruct $lang >/dev/null 2>&1
scons -Q -f scripts/sconstruct $lang
scons -Q -f scripts/sconstruct $lang >/dev/null 2>&1
fi
echo
done

