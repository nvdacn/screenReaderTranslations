# make hyphenation korpus
#removes any words that cannot serve as hyphenation rules
# I.e. all words containing digits or punctuation will be removed

searchPattern = r"[0-9\.\-\,\_\(\)\'\+\=\{\}]"
removedFileName = "removed.txt"
linesProcessed = linesRemoved = 0

import re
import sys

argv = sys.argv
if len (argv) == 3:
	with open(argv[1]) as inFile, open(argv[2], "w") as outFile, open(removedFileName, "w") as removedFile:
		for line in inFile:
			linesProcessed = linesProcessed+1
			
			if re.search( searchPattern, line, flags=0) != None \
			or len(line) <= 2:
				linesRemoved = linesRemoved+1
				removedFile.write(line)
			else:
				outFile.write(line)
			#endif
		#endfor
	#endwith
	inFile.close()
	outFile.close()
	removedFile.close()
	
	print linesProcessed, "lines processed."
	print linesRemoved, "lines removed."
else:
	print "usage: makeHyphenationKorpus infile outfile"
#endif

