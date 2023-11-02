#!/bin/bash

#udapy -s read.Conllu files='!manual/*.conllu' zone=gold read.Conllu files='!reparse/*.conllu' zone=auto > poetree-all.conllu
cat poetree-all.conllu | udapy -s util.ResegmentGold > poetree-resegmented.conllu
cat poetree-resegmented.conllu | udapy util.MarkDiff gold_zone=gold attributes='deprel' ignore_parent=0 write.TextModeTreesHtml > poetree-diff.html
