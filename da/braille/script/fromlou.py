# fromlou
# This script converts a file from LibLouis notation back to the default encoding.

import sys
argv = sys.argv

if len (argv) == 3:

	linesProcessed = 0
	with open(argv[1]) as inFile, open(argv[2], "w") as outFile:

		for inLine in inFile:

			stringHolder = []
			i = 0
			while i < len(inLine):
				if inLine[i:i+2] == r"\x":
					numString = "0x" + inLine[i+2:i+6]
					stringHolder.extend( chr(int(numString, base=16)))
					i = i+6
				else:
					stringHolder.extend ( inLine[i])
					i = i+1
				#endif
			#endwhile
			outline = "".join(stringHolder)
			outFile.write(outline)
			linesProcessed = linesProcessed+1
		#endfor

		inFile.close()
		outFile.close()
	#endwith
	print linesProcessed, "lines processed."

else:

	print "Usage: fromlou infile outfile."
#endif
