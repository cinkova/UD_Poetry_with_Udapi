#!/bin/bash

#cat all.conllu | udapy -s util.ResegmentGold > all-resegmented.conllu

if false; then
cat all-resegmented.conllu | udapy -q util.MarkDiff gold_zone=gold attributes='deprel' ignore_parent=0 mark_attr=ParseErr \
 util.Mark mark_attr=PreGenNmod print_stats=1 zones=gold node='(node < node.parent
  and node.feats["Case"]=="Gen"
  and node.udeprel == "nmod"
  and not any(c.udeprel=="case" for c in node.children)
  and node.upos in "NOUN PROPN PRON".split()
)' \
 write.Conllu files=all-marked.conllu
fi

echo === GOLD ==== > generated/stats-edge-len.txt
cat all-marked.conllu | udapy -q \
 util.See zones=gold n=99 stats=edge node='node.misc["PreGenNmod"] and node.misc["ParseErr"]' \
 util.See zones=gold n=99 stats=edge node='node.misc["PreGenNmod"]' \
>> generated/stats-edge-len.txt

echo -e "\n=== AUTO ====" >> generated/stats-edge-len.txt
cat all-marked.conllu | udapy -q \
 util.See zones=auto n=99 stats=edge node='node.misc["PreGenNmod"] and node.misc["ParseErr"]' \
 util.See zones=auto n=99 stats=edge node='node.misc["PreGenNmod"]' \
>> generated/stats-edge-len.txt
