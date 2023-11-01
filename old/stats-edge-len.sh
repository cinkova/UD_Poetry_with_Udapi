#!/bin/bash

#cat all.conllu | udapy -s util.ResegmentGold > all-resegmented.conllu

if true; then
cat all-resegmented.conllu | udapy -q \
 util.MarkDiff gold_zone=gold attributes='form'   ignore_parent=1 mark_attr=0 align=both \
 util.MarkDiff gold_zone=gold attributes='deprel' ignore_parent=0 mark_attr=ParseErr \
 util.Mark mark_attr=PreGenNmod print_stats=1 zones=gold node='(node < node.parent
  and node.feats["Case"]=="Gen"
  and node.udeprel == "nmod"
  and not any(c.udeprel=="case" for c in node.children)
  and node.upos in "NOUN PROPN PRON".split()
)' \
 .ProjectMisc attr=PreGenNmod \
 write.Conllu files=all-marked.conllu
fi

if true; then
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
fi

for zone in gold auto; do
    cat all-marked.conllu | udapy -q \
    util.Eval zones=$zone node='print("\t".join([
    str(node.ord),
    str(node.parent.ord),
    node.deprel,
    node.misc["PreGenNmod"],
    node.misc["ParseErr"],
    ]))' > generated/stats-edges-poetree-$zone.txt
done
