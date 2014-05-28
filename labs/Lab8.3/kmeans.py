#!/usr/bin/env python

import fileinput
import string

replace_punctuation = string.maketrans(string.punctuation, ' '*len(string.punctuation))
current_topic = ""
total_length = 0
for line in fileinput.input():
    line = line.strip()
    fields = line.split('\t')
    content = fields[2].translate(replace_punctuation)
    if not current_topic:
      current_topic = fields[0]
    elif current_topic != fields[0]:
      print "%s\t%d" % (current_topic, total_length)
      current_topic = fields[0]
      total_length = 0
    total_length = total_length + len(content)
print "%s\t%d" % (current_topic, total_length)
