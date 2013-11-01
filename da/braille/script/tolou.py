# encoding: cp1252
# This script converts a file from the standard string encoding to LibLouis format
# i.e. all characters above 0x7f are replaced with the corresponding hex value.

import sys
argv = sys.argv

if len (argv) == 3:

	linesProcessed = 0
	with open(argv[1]) as inFile, open(argv[2], "w") as outFile:

		for inLine in inFile:
	
			stringHolder = []

			for c in inLine:
				if ord(c) >= 0x7f:
					stringHolder.extend("\\x%04x" % ord(c))
				else:
					stringHolder.extend(c)
				#endif
#endfor
			outline = "".join(stringHolder)
			outFile.write(outline)
			linesProcessed = linesProcessed+1
		#endfor

		inFile.close()
		outFile.close()
	#endwith
	print linesProcessed, "lines processed."

else:

	print "Usage: tolou infile outfile."
#endif
