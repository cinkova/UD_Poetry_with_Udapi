#!/bin/bash

# TODO automatic uses czech-pdt-ud-2.10-220711
# but the newest is   czech-pdt-ud-2.12-230717

mkdir -p raw reparse
for f in automatic/*.conllu; do
  fn=${f#automatic/}
  fn=${fn%.conllu}
  echo ======= Processing $f
  cat $f | udapy write.Sentences | paste -s -d " " > raw/$fn.txt
  cat raw/$fn.txt | udapy -s read.Sentences udpipe.Cs model=czech-pdt-ud-2.12-230717 resegment=1 online=1 util.Normalize sent_id_prefix=${fn%.conllu}_ > reparse/$fn.conllu
done
