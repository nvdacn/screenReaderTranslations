# Compare two files
# writes the differences seperated by ccomma
# to be used with files with one word pr line
import sys

if len(sys.argv) == 4:
	print "comparing", sys.argv[1], "and", sys.argv[2]

	linesProcessed = diffs = 0
	diffsList = []
	with open(sys.argv[1]) as file1, open(sys.argv[2]) as file2:
		while True:
			line1 = file1.readline()
			if line1 == "":
				break
			#endif
			line2 = file2.readline()
			if line2 == "":
				break
			#endif
			linesProcessed = linesProcessed+1
			if line1 != line2:
				diffs = diffs+1
				diffsList= diffsList + [line1[:-1] + " " + line2]
				
			#endif
		#endwhile
	#endwith
	file1.close()
	file2.close()
	print linesProcessed, "lines processed"
	print diffs, "differences found"
	if len(diffsList) > 0:
		print "writing differences to", sys.argv[3]
		with open(sys.argv[3],"w") as outFile:
			for outline in diffsList:
				outFile.write(outline)
			#endfor
		#endwith
		outFile.close()
	#endif
	
else:
	print "Usage: compare file1 file2 diffsfile"
#endif
