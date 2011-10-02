#!/usr/bin/python
import re

f = open('userGuide.html')
lines = f.readlines()
f.close()

info = []
newSec = re.compile('\<H[0-9]>(?P<id>([0-9]+\.)+)')
pars = 0
tables = 0
lists = 0
id = ''
i = 0
for i in range(len(lines)):
    if lines[i].startswith("<P>"):
        pars +=1; continue
    if lines[i].startswith("<TABLE "):
        tables +=1; continue
    if lines[i].startswith("<OL>") or lines[i].startswith("<UL>"):
        lists +=1; continue
    PnewSec = newSec.match(lines[i])
    if PnewSec:
        if id:
            info.append((id, i+1, pars, tables, lists))
        pars = 0; tables = 0; lists = 0
        id = PnewSec.groupdict()['id']

# make sure to add the last section info.
if id:
    info.append((id, i+1, pars, tables, lists))
    pars = 0; tables = 0; lists = 0

f = open('ug-stats.txt', 'w')
f.write("# section number, section starts at line, paragraphs in this section, tables in this section, tables in this section.\n")
for i in info:
    f.write("%s sectionStart:%d paragraphs:%d, tables:%d, lists:%d\n\n" %(i[0],i[1], i[2], i[3], i[4] ))
f.close()


