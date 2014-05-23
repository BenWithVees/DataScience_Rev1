#!/usr/bin/python

import fileinput
from nltk import FreqDist
from nltk.tokenize import RegexpTokenizer

lines = ""
for line in fileinput.input():
	line=line.strip()
	lines += line + " "

tokenizer = RegexpTokenizer(r'\w+')
freq = FreqDist(tokenizer.tokenize(lines))
for k in freq.keys()[:50]:
	print "%s\t%s" % (k, freq[k])
