#!/usr/bin/python
import sys, os, Image

def usage():
	print "[!] Usage: %s <textfile> <outimage>.png"%sys.argv[0]
	exit(-1)

if (len(sys.argv) == 3):
	try:
		string = open(sys.argv[1]).read()
	except:
		print "[!] Error reading file!"
		exit(-1)
else:
	usage()

if (len(string) > 3072):
	print "[*] Error: file too large for favicon"
	exit(-1)

chrVals = []
for x in string:
	chrVals.append(ord(x))

img    = Image.new("RGB",(32,32),"black")
pixels = img.load()

locIndex = 0    # used to track which pixel we are on

for z in range(0,len(chrVals),3):
	try:
		pixels[locIndex%32,locIndex/32] = (chrVals[z],chrVals[z+1],chrVals[z+2])
		locIndex += 1
	except:
		pass

img.save(sys.argv[2])
