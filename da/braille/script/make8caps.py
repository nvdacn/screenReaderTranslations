def l_o_capitalize (lOperand):

	if lOperand[0] == "\\":
		if lOperand[4].upper() == "E":
			return lOperand[:4] + "C" + lOperand[5:]
		elif lOperand[4].upper() == "F":
			return lOperand[:4] + "D" + lOperand[5:]
		else:
			return lOperand
	else:
	
		return lOperand.capitalize()
	#endif
#enddef	

def b_o_capitalize(bOperand):
	bCells = bOperand.split("-")
	if bCells[0].isdigit():
		bCells[0] = bCells[0] + "7"
	#endif
	return "-".join(bCells)
#enddef

def find_opcode_index(words):
	ValidOpcodes = ["word", "begword", "midword", "midendword", "endword", "sufword", "preword", "always", "nocross", "contraction"]
	for i in range(len(words)):
		for j in ValidOpcodes:
			
			if words[i] == j:
				return i
			#endif
		#endfor j
	#endfor i
	
	#not found
	print "Skipped:", " ".join(words)
	return -1
#enddef

def process_line (sLine):
	if sLine[0] == "#":
		return sLine
	#endif
	
	if sLine[0] == "\n":
		return sLine
	#endif
	
	

	sWords = sLine.split()
	opcIndex = find_opcode_index (sWords)
	if opcIndex >= 0:
		lOIndex, bOIndex = opcIndex + 1, opcIndex + 2
		if lOIndex < len(sWords):
			sWords [lOIndex] = l_o_capitalize(sWords[lOIndex])
		#endif
	
		if bOIndex < len(sWords):
			sWords [bOIndex] = b_o_capitalize(sWords[bOIndex])
		#endif
	else:
		return ""
		#No relevant opcode or comment, so return empty string
		
	#endif
	
	return " ".join(sWords) + "\n"
#enddef

infile = open ("da-dk-g2core.cti","r")
outfile = open ("da-dk-g28caps.cti", "w")
linesProcessed = linesWritten = 0

for line in infile:
	line = process_line (line)
	linesProcessed= linesProcessed+1
	if line != "":
		outfile.write (line)
		linesWritten = linesWritten + 1
	#endif
#endfor
infile.close ()
outfile.close ()

print linesProcessed, "lines processed"
print linesWritten, "lines written"
