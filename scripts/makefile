include settings
SHELL = /bin/bash
lang = $(shell basename $(PWD))

T2TFILES = changes.t2t userGuide.t2t
HTMLFILES = $(patsubst %.t2t,%.html,$(T2TFILES))

%.utf: %.t2t
	# checking for non utf8 or ascii files $?
	@../scripts/checkEncoding.sh
	touch $@

keyCommands.t2t: userGuide.utf
	# creating keyCommands.t2t from userGuide.t2t
	@python2.7 ../scripts/keyCommandsDoc.py

ug-stats.txt: userGuide.utf
	# recalculating userGuide stats
	@python ../scripts/stats.py

ug-stats-diff.txt: ug-stats.txt
	# rebuilding userGuide stats differences
	@../scripts/remakeStats.sh $(lang)

%.html: %.utf
	# convert $*.t2t to $@
	@txt2tags -q -o $@ $(<:.utf=.t2t)

convert: $(HTMLFILES) keyCommands.html ug-stats.txt ug-stats-diff.txt
	@mfiles=`git status -s -uno . | grep -iP 'settings|.[html|txt]$$' | awk '{printf(" %s", $$2)}'`; \
	msg="${lang}: updated $$mfiles"; \
	if [ "$$mfiles" != "" ]; then \
	echo "# committing %msg" \
	git commit -q -m "$msg" $$mfiles; \
	fi


