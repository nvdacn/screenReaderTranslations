#!/bin/bash
# MMH, 18 Jul, 2010.
#

# checking for the existance of needed programs
#
ELINKS=`which elinks`
POCOUNT=`which pocount`
MSGMERGE=`which msgmerge`
CURL=`which curl`

if [ "$ELINKS" == "" ]; then
    echo "Can't find elinks."
    exit
elif [ "$POCOUNT" == "" ]; then
    echo "Can't find pocount."
    exit
elif [ "$MSGMERGE" == "" ]; then
    echo "Can't find msgmerge."
    exit
elif [ "$CURL" == "" ]; then
    echo "Can't find curl."
    exit
fi


snapUrl='http://nvda.sourceforge.net/snapshots/.index.html'
url=`$ELINKS --dump $snapUrl | grep -i '.pot' | head -n 1 | awk '{ print \$2 }'`
commitMsg=""

# if the content of the var end in pot then we have the url.
#
exist="${url##*.}"
if [ "$exist" != "pot" ]; then
    echo "$0: Could not find po file on website."
    exit
fi

$CURL -s -o /tmp/nvda.pot $url

# Navigate to the base of the svn repo.
absPath=`readlink -f -n $0`
absPath=`dirname $absPath`
pushd ${absPath}/../ >/dev/null 2>&1
langs=(ar de fi it ja nl pl sv ta tr)
for lang in ${langs[*]}; do
    echo "processing $lang"
    cd $lang

    # restore nvda.po in case of modifications and pull from server.
    #
    git checkout -f nvda.po

    # finding statistics before updating against pot file.
    #
    bfuzzy=`$POCOUNT nvda.po | grep -i fuzzy | awk '{print \$2}'`
    buntranslated=`$POCOUNT nvda.po | grep -i untranslated | awk '{print \$2}'`
    bmsg="$bfuzzy fuzzy messages, and $buntranslated untranslated messages."

    # update po file from downloaded pot
    #
    echo "updating po from pot."
    $MSGMERGE -q -U nvda.po /tmp/nvda.pot

    # finding statistics after updating against pot file.
    #
    afuzzy=`$POCOUNT nvda.po | grep -i fuzzy | awk '{print \$2}'`
    auntranslated=`$POCOUNT nvda.po | grep -i untranslated | awk '{print \$2}'`
    amsg="$afuzzy fuzzy messages, and $auntranslated untranslated messages."

    # checking if we need to do anything
    #
    if [ "$bmsg" == "$amsg" ]; then
        # nothing has changed, dont need to action.
        # revert because comments in po file might have changed.
        #
        git checkout -f nvda.po
        echo "$0: nvda.po file is up to date, nothing to do."
    else
        # need to commit, because before and after are diffrent.
        #
        commitMsg="${commitMsg}${lang}: 
    before: ${bmsg}
    now: ${amsg}

"
       git add nvda.po
        echo "$0 ${lang}: nvda.po has been updated from pot."
    fi
    cd ..
done

popd >/dev/null 2>&1 

rev=${url##*/}
rev=`echo "$rev" | grep -o -P "[0-9]+"`
git commit -q -m "Merging in messages from rev${rev} into nvda.po

$commitMsg"
./commit.sh
