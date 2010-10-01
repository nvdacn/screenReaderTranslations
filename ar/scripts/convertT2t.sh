#!/bin/bash
# MMH, 30 Sep, 2010.
#
# Convert our arabic t2t files to html.

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

# navigate to the ar/scripts dir.
absPath=`readlink -f -n $0`
absPath=`dirname $absPath`
pushd ${absPath} >/dev/null 2>&1

cd  ..
for f in *_ar.t2t; do
echo "Converting $f to utf8."; 
$ICONV -f utf16 -t utf8 <${f} >tmp.t2t
mv tmp.t2t ${f}
done

$PYTHON27 ./scripts/generate.py

for f in *_ar.t2t; do
git checkout ${f}
done

mfiles=`git status -s -uno | grep -i ".html$" | awk '{printf(" %s", $2)}'`
if [ "$mfiles" != "" ]; then
git add $mfiles
msg="Updated $mfiles from t2t."
echo "$msg"
git commit -m "$msg"
cd scripts
./commit.sh
fi

