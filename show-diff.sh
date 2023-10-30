#!/bin/bash

#udapy -s read.Conllu files='!manual/*.conllu' zone=gold read.Conllu files='!reparse/*.conllu' zone=auto > all.conllu
cat all.conllu | udapy -s util.ResegmentGold > all-resegmented.conllu
cat all-resegmented.conllu | udapy util.MarkDiff gold_zone=gold attributes='deprel' ignore_parent=0 write.TextModeTreesHtml > all-diff.html
