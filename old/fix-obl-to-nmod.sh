#!/bin/bash

cat all.conllu | udapy -s \
 util.Eval node='if (node.udeprel == "obl"
  and node.upos in "NOUN PROPN PRON".split()
  and node.parent.upos in "NOUN PROPN PRON".split()
  and not any(c.udeprel == "cop" for c in node.parent.children)
  and node.parent.udeprel != "orphan"
  and node.root.sent_id != "0973-0001-0000-0000-0004-0000_12/gold"
): node.deprel = "nmod"' \
 > fixed-all.conllu
