#!/usr/bin/python
# otlreorder.py
# Grep and reorder an outline for a regex and return the branch 
# with all the leaves.
#
# Copyright 2006 Noel Henson All rights reserved
#
# $Revision: 1.7 $
# $Date: 2008/09/17 21:34:25 $
# $Author: noel $
# $Source: /home/noel/active/otlreorder/RCS/otlreorder.py,v $
# $Locker:  $

###########################################################################
# Basic function
#
#	This program searches an outline file for a branch that contains
#	a line matching the regex argument. The parent headings (branches) 
#	and the children (sub-branches and leaves) of the matching headings
#	are returned with the outline focused on the search term.
#
#	Examples
#	
#	Using this outline:
#
#	Pets
#	Indoor
#		Cats
#			Sophia
#			Hillary
#		Rats
#			Finley
#			Oliver
#		Dogs
#			Kirby
#	Outdoor
#		Dogs
#			Kirby
#			Hoover
#		Goats
#			Primrose
#			Joey
#
#	a reorder for Sophia returns:
#
#	Sophia
#		Indoor
#			Cats
#
#	a reorder for Dogs returns:
#
#	Dogs
#		Indoor
#			Kirby
#			Hoover
#		Outdoor
#			Kirby
#			Hoover
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

###########################################################################
# include whatever mdules we need

import sys
from string import *
from re import *

###########################################################################
# global variables

debug = 0
ignorecase = 0
pattern = ""
patterns = []
completePatterns = []
inputfile = ""
lines = []

###########################################################################
# function definitions# usage
#
# print debug statements
# input: string
# output: string printed to standard out

def dprint(*vals):
	global debug
	if debug != 0: print vals

# usage
# print the simplest form of help
# input: none
# output: simple command usage is printed on the console
 
def showUsage():
   print
   print "Usage:"
   print "otlreorder.py [options] pattern [pattern...] [file]"
   print "Options"
   print "    -             use STDIN instead of file"
   print "    -i            Ignore case"
   print "    --version     Print version (RCS) information."
   print "    --help        Show help."
   print "[file...] is zero or more files to search. Wildcards are supported."
   print "          if no file is specified, input is expected on stdin."
   print "output is on STDOUT"
   print

# version
# print the RCS version information
# input: none
# output: RSC version information is printed on the console
 
def showVersion():
   print
   print "RCS"
   print " $Revision: 1.7 $"
   print " $Date: 2008/09/17 21:34:25 $"
   print " $Author: noel $"
   print

# getArgs
# Check for input arguments and set the necessary switches
# input: none
# output: possible console output for help, switch variables may be set

def getArgs():
  global debug, pattern, inputfile, ignorecase
  usestdin = 0
  if (len(sys.argv) == 1): 
    showUsage()
    sys.exit()()
  else:
    for i in range(len(sys.argv)):
      if (i != 0):
        if   (sys.argv[i] == "-d"): debug = 1	# test for debug flag
        elif (sys.argv[i] == "-"): usestdin = 1	# test for debug flag
        elif (sys.argv[i] == "-i"): ignorecase = 1	# test for debug flag
        elif (sys.argv[i] == "-?"):		# test for help flag
	  showUsage()				# show the help
	  sys.exit()				# exit
        elif (sys.argv[i] == "--help"):
	  showUsage()
	  sys.exit()
        elif (sys.argv[i] == "--version"):
	  showVersion()
	  sys.exit()
	elif (sys.argv[i][0] == "-"):
	  print "Error!  Unknown option.  Aborting"
	  sys.exit()
	else: 					# get the input file name
	  patterns.append(sys.argv[i])
    if (usestdin == 0):
	    inputfile = patterns.pop()

# getLineLevel
# get the level of the current line (count the number of tabs)
# input: linein - a single line that may or may not have tabs at the beginning
# output: returns a number 1 is the lowest

def getLineLevel(linein):
  strstart = lstrip(linein)			# find the start of text in line
  x = find(linein,strstart)			# find the text index in the line
  n = count(linein,"\t",0,x)			# count the tabs
  return(n+1)					# return the count + 1 (for level)

# processFile
# split an outline file
# input: file - the filehandle of the file we are splitting
# output: output files

def processFile(pattern):

  global lines, debug, ignorecase

  parents = []
  parentprinted = []

  parents.append("pattern")
  parentprinted.append(0)

  for i in range(10):
	  parents.append("")
	  parentprinted.append(0)

  matchlevel = 0

  i = 1
  while (i < len(lines)):
  	  line = lines[i]
	  level = getLineLevel(line)
	  line = "\t"+line
	  parents[level] = line
	  parentprinted[level] = 0
#	  if (ignorecase == 1): linesearch = search(pattern,lstrip(rstrip(line)),I)
#	  else: linesearch = search(pattern,lstrip(rstrip(line)))
#	  if (linesearch != None):
	  if (pattern == lstrip(rstrip(line))):
		  if parents[0] != lstrip(line):
			  parents[0] = lstrip(line)
			  parentprinted[0] = 0
		  matchlevel = level
		  # print my ancestors
		  for j in range(level):	
			  if (parentprinted[j] == 0):
				  print parents[j][:-1]
				  parentprinted[j] = 1
		  # print my decendents
		  i = i + 1
		  if i >= len(lines): return
		  line = lines[i]
		  level = getLineLevel(line)
		  while (i < len(lines)) and (getLineLevel(line) > matchlevel):
			  if (i < len(lines)):
				  line = lines[i]
				  level = getLineLevel(line)
				  if (level > matchlevel):
					  print line[:-1]
				  else: i = i - 1
			  i = i + 1
		  i = i - 1
	  i = i + 1
	
# getCompletePattern
# search lines for pattern matches to generate a specific list of patterns to search for
# input: pattern and lines
# output: patterns updated with specific, complete patterns

def getCompletePattern(pattern):
  global completePatterns, lines, debug, ignorecase
  for i in range(len(lines)):
  	  line = lines[i]
	  if (ignorecase == 1): linepattern = search(pattern,lstrip(rstrip(line)),I)
	  else: linepattern = search(pattern,lstrip(rstrip(line)))
	  if (linepattern != None):
		  completePatterns.append(lstrip(rstrip(line)))
		  if debug != 0: print lstrip(rstrip(line))

# getCompletePatterns
# search lines for pattern matches to generate a specific list of patterns to search for
# input: pattern and lines
# output: patterns updated with specific, complete patterns

def getCompletePatterns():
  global completePatterns, patterns, debug
  for i in range(len(patterns)):
	  getCompletePattern(patterns[i])
  if (debug!=0):
	  print "patterns:"
	  for i in range(len(patterns)): print patterns[i]
  # perform the equivalent of the sort | uniq
  completePatterns.sort()
  unionPatterns = set(completePatterns)
  unionPatterns.union(unionPatterns)
  completePatterns = list(unionPatterns)
  if (debug!=0):
	  print "complete patterns:"
	  for i in range(len(completePatterns)): print completePatterns[i]

# main
# split an outline
# input: args and input file
# output: output files

def main():
  global lines, inputfile, completePatterns, patterns, debug
  getArgs()
  if (len(inputfile) == 0):
	  line = sys.stdin.readline()
	  while (line != ""):
		  lines.append(line)
		  line = sys.stdin.readline()
  else:
	  file = open(inputfile,"r")
	  line = file.readline()
	  while (line != ""):
		  lines.append(line)
		  line = file.readline()
	  file.close()
  getCompletePatterns()
  for i in range(len(completePatterns)):
	  processFile(completePatterns[i])  
main()
