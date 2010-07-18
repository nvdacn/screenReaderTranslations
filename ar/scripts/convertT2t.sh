#!/bin/bash
# MMH, 18 Jul, 2010.
#
# Convert our arabic t2t files to html.
TXT2TAGS=`which txt2tags`
ICONV=`which iconv`


if [ "$TXT2TAGS" == "" ]; then
    echo "unable to find txt2tags, can not continue."
    exit;
elif [ "$ICONV" == "" ]; then
    echo "unable to find iconv, can not continue."
    exit;
fi

function convt2t {
    infile=$1; shift;
    outfile="${infile%.*}.html"
    echo "processing $infile"

    pushd ../ >/dev/null 2>&1
    $ICONV -f "utf-16" -t "utf-8" <${infile} >iconvOut.t2t
    $TXT2TAGS -t html iconvOut.t2t
    mv iconvOut.html $outfile
    rm iconvOut.t2t
    popd >/dev/null 2>&1
    echo "done."
}

# navigate to the ar/scripts dir.
absPath=`readlink -f -n $0`
absPath=`dirname $absPath`
pushd ${absPath} >/dev/null 2>&1

convt2t userGuide_ar.t2t
convt2t changes_ar.t2t

popd >/dev/null 2>&1
