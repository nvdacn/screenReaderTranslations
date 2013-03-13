#!/usr/bin/env bash

source checkProgs.sh

function usage() {
    echo "`basename $0` [-h]"
    echo "`basename $0`  <-f|-t>" [-l 'ar de fi']
    echo "    -h, (help) prints this help message."
    echo "    -f, (fromTranslators) copies files fromTranslators to vcs"
    echo "    -t, (toVcs) copies/merges files from vcs to translators"
    echo "    -l, (langs) process only the given languages"
    echo "    -a, (addons) process only the given addons"
}

langs=(am an ar bg cs da de el es fi fr gl hr hu it is ja ko ne nl nb_NO nn_NO pl pt_BR pt_PT ru sk sl sv ta tr uk zh_CN zh_HK zh_TW)

while getopts a:fhtl: OPT; do
    case "$OPT" in
        (h) usage; exit 0;;
        (f) fromTranslators=1 ;;
        (t) toTranslators=1 ;;
        (l) langs=($OPTARG) ;;
        (a) availableAddons=($OPTARG) ;;
        (\?)
            # getopts issues an error message
            echo usage >&2
            exit 1
            ;;
    esac
done


if [ "$fromTranslators" == "$toTranslators" -a "$fromTranslators" == "" ]; then
    echo "error: need either '-f' fromTranslators, or -t, toTranslators"
    usage; exit 1
elif  [ "$fromTranslators" == "$toTranslators" -a "$fromTranslators" == "1" ]; then
    echo "error: '-f' and '-t' are mutually exclusive."
    usage; exit 1
fi

# make sure we have somewhere where we can store our temporary files
TMPDIR=/tmp/potfiles/
if [ -e $TMPDIR ]; then
    rm -rf $TMPDIR
    if [ "$?" != "0" ]; then
        echo "could not remove $TMPDIR, refuse to continue."
        exit 1;
    fi
fi
mkdir -p $TMPDIR

addonOffset="../../addons/"
# go through all addons and generate their pot files, place them in our temp dir.
for addon in ${availableAddons[*]}; do
    pushd "${addonOffset}/${addon}" >/dev/null 2>&1
    pwd
    scons -Q pot mergePot
    mv *.pot $TMPDIR
    popd >/dev/null 2>&1
done

for lang in ${langs[*]}; do
    echo -ne "\nprocessing ${lang}:"
    # relative path from scripts directory to language directory.
    langOffset=../$lang
    if [ -e "${langOffset}/settings" ]; then
        source "${langOffset}/settings"
    else
        echo "warning: No settings file found, skipping."
        continue
    fi
    for addon in ${availableAddons[*]}; do
        eval process=\$${addon}
        if [ "$process" == "0" ]; then
            echo -n " skipping:$addon"
            continue
        fi
        if [ "$fromTranslators" == "1" ]; then
            srcPo="${langOffset}/add-ons/${addon}/nvda.po"
            targetPo="${addonOffset}/${addon}/addon/locale/${lang}/LC_MESSAGES/nvda.po"
            #echo "  checking nvda.po:"
            msgfmt  -c -o /tmp/tmp.mo "$srcPo"
            if [ "$?" == "0" ]; then
                #echo "  copying across nvda.po"
                mkdir -p "${addonOffset}/${addon}/addon/locale/${lang}/LC_MESSAGES"
                cp "$srcPo" "$targetPo"
            fi
            echo -n " ${addon}"
        else
            srcPo="${langOffset}/add-ons/${addon}/nvda.po"
            potFile="${TMPDIR}/${addon}.pot"
            mergePotFile="${TMPDIR}/${addon}-merge.pot"
            mkdir -p "${langOffset}/add-ons/${addon}/"
            if [ ! -e $srcPo ]; then
                cp "${potFile}" "${srcPo}"
                sed -i -e 's+"Content-Type: text/plain.*"+"Content-Type: text/plain; charset=UTF-8\\n"+g' \
                -e "s/^\"Language:\ /\"Language:${lang}/g" "${srcPo}"
                svn add "${langOffset}/add-ons/${addon}/"
            fi
            msgmerge -qU "${srcPo}" "${mergePotFile}"
            echo -n " ${addon}"
        fi
    done
done
echo -e "\nall done"
