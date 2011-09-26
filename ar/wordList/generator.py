#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import sys
from nounsAndVerbs import *

fatha = "َ"
dumma = "ُ"
kasra = "ِ"

f = open("out.txt", "w")
# dealing with nouns
f.write("## nouns:\n\n")

# default is to have a fatha after first letter.
f.write("# default:\n")
for word in nouns:
    letter1 = word.decode("utf-8")[0].encode("utf-8")
    letter2 = word.decode("utf-8")[1].encode("utf-8")
    letter3 = word.decode("utf-8")[2].encode("utf-8")
    f.write(letter1+ fatha+ letter2+ letter3+ "\n")

# plural noun, should have dumma between first and second, and second and third.
f.write("\n# plural nouns:\n")
for word in nouns:
    letter1 = word.decode("utf-8")[0].encode("utf-8")
    letter2 = word.decode("utf-8")[1].encode("utf-8")
    letter3 = word.decode("utf-8")[2].encode("utf-8")
    f.write(letter1+ dumma+ letter2+ dumma+ letter3+"\n")



# some more work for nouns goes here,

# some work for verbs goes here.
f.close()

