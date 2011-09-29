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
for line in lines:
    if line.startswith("<P>"):
        pars +=1; continue
    if line.startswith("<TABLE "):
        tables +=1; continue
    if line.startswith("<OL>") or line.startswith("<UL>"):
        lists +=1; continue
    PnewSec = newSec.match(line)
    if PnewSec:
        if id:
            info.append((id, pars, tables, lists))
            pars = 0; tables = 0; lists = 0
        id = PnewSec.groupdict()['id']

f = open('userGuide-stats.txt', 'w')
for i in info:
    f.write("%s paragraphs:%d, tables:%d, lists:%d\n" %(i[0],i[1], i[2], i[3] ))
f.close()


