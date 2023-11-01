#!/bin/bash

#cat all.conllu | udapy -s util.ResegmentGold > all-resegmented.conllu

if true; then
cat all-resegmented.conllu | udapy -q \
 util.MarkDiff gold_zone=gold attributes='form'   ignore_parent=1 mark_attr=0 align=both \
 util.Mark mark_attr=PreGenNmod print_stats=1 zones=gold node='(node < node.parent
  and node.feats["Case"]=="Gen"
  and node.udeprel == "nmod"
  and not any(c.udeprel=="case" for c in node.children)
  and node.upos in "NOUN PROPN PRON".split()
)' \
 write.Conllu files=all-marked.conllu
fi

cat all-marked.conllu | udapy .EdgeStats files=generated/stats-poetree-edges.tsv misc_attrs=PreGenNmod
