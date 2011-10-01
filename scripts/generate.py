#generate.py
#A part of NonVisual Desktop Access (NVDA)
#This file is covered by the GNU General Public License.
#See the file COPYING for more details.
#Copyright (C) 2006-2010 Michael Curran <mick@kulgan.net>, James Teh <jamie@jantrid.net>

"""Script to prepare an NVDA source tree for optimal execution.
This script:
* Generates the HTML documentation.
"""

import sys
import os
from glob import glob
import txt2tags
import keyCommandsDoc

def main():
	#print "HTML documentation (except Key Commands):"
	files = glob(r"*.t2t")
	# Using txt2tags as a module to handle files is a bit weird.
	# It seems simplest to pretend we're running from the command line.
	for f in files:
		try:
			txt2tags.exec_command_line(['-q', f])
		except UnicodeDecodeError:
			print "ERROR: %s is not in unicode utf8, could not process." %f

	#print "Key Commands documentation:"
	files = glob(r"./userGuide.t2t")
	for f in files:
		maker = keyCommandsDoc.KeyCommandsMaker(f)
		#print maker.kcFn
		try:
			if maker.make():
				txt2tags.exec_command_line(['-q', maker.kcFn])
			else:
				print "WARNING: User Guide does not contain key commands markup, skipping"
		except UnicodeDecodeError:
			print "ERROR: %s is not in unicode utf8, could not process." % maker.kcFn
		finally:
			maker.remove()

if __name__ == "__main__":
	main()
