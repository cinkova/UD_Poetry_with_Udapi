#!/bin/bash
PDT_DIR=/net/data/universal-dependencies-2.12/UD_Czech-PDT/
PART=test

# parse
#udapy -s read.Text files=$PDT_DIR/cs_pdt-ud-$PART.txt zone=auto udpipe.Cs online=1 resegment=1 > pdt-$PART-auto.conllu

udapy -s \
  read.Conllu files=$PDT_DIR/cs_pdt-ud-$PART.conllu zone=gold \
  read.Conllu files=pdt-$PART-auto.conllu zone=auto \
  > pdt-$PART-all.conllu
cat pdt-$PART-all.conllu | udapy -s util.ResegmentGold > pdt-$PART-resegmented.conllu
