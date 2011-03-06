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

# if the content of the var end in pot then we have the url.
#
echo "i got so far."
exist="${url##*.}"
if [ "$exist" != "pot" ]; then
    echo "$0: Could not find po file on website."
    exit
fi

$CURL -s -o /tmp/nvda.pot $url

# navigate to the ar dir.
absPath=`readlink -f -n $0`
absPath=`dirname $absPath`
pushd ${absPath}/../ >/dev/null 2>&1

# restore nvda.po in case of modifications and pull from server.
#
git checkout nvda.po; git svn rebase

# finding statistics before updating against pot file.
#
bfuzzy=`$POCOUNT nvda.po | grep -i fuzzy | awk '{print \$2}'`
buntranslated=`$POCOUNT nvda.po | grep -i untranslated | awk '{print \$2}'`
bmsg="$bfuzzy fuzzy messages, and $buntranslated untranslated messages."

# update po file from downloaded pot
#
echo "updating po from pot."
$MSGMERGE -U nvda.po /tmp/nvda.pot

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
    git checkout nvda.po
    echo "$0: nvda.po file is up to date, nothing to do."
else
    # need to commit, because before and after are diffrent.
    #
    rev=${url##*/}
    rev=`echo "$rev" | grep -o -P "[0-9]+"`
    commitMsg="Merging in messages from rev${rev} into nvda.po:

    before: ${bmsg}
    now: ${amsg}"
   git commit -m "$commitMsg" nvda.po
    ./scripts/commit.sh
    echo "$0: nvda.po has been updated from pot."
fi

popd >/dev/null 2>&1 
