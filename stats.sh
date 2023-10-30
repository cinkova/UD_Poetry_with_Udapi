#!/bin/bash

#cat all.conllu | udapy -s util.ResegmentGold > all-resegmented.conllu
#cat all-resegmented.conllu | udapy util.MarkDiff gold_zone=gold attributes='form,lemma,upos,deprel,feats' print_stats=50 > all-diff-stats.txt

# Místo         node.upos in "NOUN PROPN PRON".split()
# by šlo použít node.upos not in "ADJ DET ADP NUM".split()
# Na současných datech to dá stejný výsledek.

# chyba v rodiči:  attributes='form' ignore_parent=0
#  47 chyb v 38 větách
# chyba v deprelu: attributes='deprel' ignore_parent=1
#  46 chyb v 35 větách
# chyba v rodiči nebo deprelu: attributes='deprel' ignore_parent=0
#  51 chyb v 40 větách

if true; then
cat all-resegmented.conllu | udapy -q util.MarkDiff gold_zone=gold attributes='deprel' ignore_parent=0 mark_attr=ParseErr \
 util.Mark print_stats=1 node='(node.misc["ParseErr"]
  and node < node.parent
  and node.feats["Case"]=="Gen"
  and node.udeprel == "nmod"
  and not any(c.udeprel=="case" for c in node.children)
  and node.upos in "NOUN PROPN PRON".split()
)' \
 util.Eval bundle='if not any(n.misc["Mark"] for n in bundle.nodes): bundle.remove()' \
 util.Wc \
 write.TextModeTreesHtml files=diffs-preposed-gen.html \
 write.Conllu files=diffs-preposed-gen.conllu
fi

# cat all-resegmented.conllu | udapy util.MarkDiff gold_zone=gold attributes='deprel' ignore_parent=0 util.See zones=gold node='node.misc["Mark"]' n=99 | less

if false; then
 cat diffs-preposed-gen.conllu | udapy \
  util.See zones=gold node='node.misc["Mark"]' n=99 > stats-preposed-gen.txt
fi

if false; then
cat all-resegmented.conllu | udapy \
  util.Mark node='(
  node < node.parent
  and node.feats["Case"]=="Gen"
  and node.udeprel == "nmod"
  and not any(c.udeprel=="case" for c in node.children)
  and node.upos in "NOUN PROPN PRON".split()
)' \
  util.See zones=gold node='node.misc["Mark"]' n=99 > stats-any-gen.txt
fi

