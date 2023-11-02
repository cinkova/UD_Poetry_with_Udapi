#!/bin/bash

#cat all.conllu | udapy -s util.ResegmentGold > poetree-resegmented.conllu

for DATA in poetree pdt-test; do
  cat $DATA-resegmented.conllu | udapy \
  util.MarkDiff gold_zone=gold attributes='form' ignore_parent=1 mark_attr=0 align=both \
  util.Mark mark_attr=PreGenNmod print_stats=1 zones=gold node='(node < node.parent
    and node.feats["Case"]=="Gen"
    and node.udeprel == "nmod"
    and not any(c.udeprel=="case" for c in node.children)
    and node.upos in "NOUN PROPN PRON".split()
  )' \
  write.Conllu files=$DATA-marked.conllu \
  .EdgeStats files=generated/stats-$DATA-edges.tsv misc_attrs=PreGenNmod
  cat generated/stats-$DATA-edges.tsv | ./analyze-edge-stats.py > generated/stats-$DATA-edges-summarized.tsv
done


