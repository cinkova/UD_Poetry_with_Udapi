#!/bin/bash
# viz https://universaldependencies.org/conll18/evaluation.html

cat all.conllu | udapy write.Conllu zones=auto > generated/all-auto-pdt.conllu
cat all.conllu | udapy write.Conllu zones=gold > generated/all-gold.conllu
git clone git@github.com:UniversalDependencies/tools.git
./tools/eval.py --verbose generated/all-gold.conllu generated/all-auto-pdt.conllu > generated/score-pdt.txt

# TODO opravit plaintext (v gold)
# gold: Do „Lumíru“ napsal
# auto: Do „Lumíru “ napsal
cat generated/all-auto-pdt.conllu | udapy write.Sentences | tr '\n' ' ' > plain-oneline-auto-pdt.txt
cat generated/all-gold.conllu     | udapy write.Sentences | tr '\n' ' ' > plain-gold.txt
diff -q plain-oneline-auto-pdt.txt plain-gold.txt

udapy read.Conllu files=generated/all-gold.conllu split_docs=1 write.Sentences docname_as_file=1
mkdir plain-oneline
for f in [01]*; do
    cat $f | tr '\n' ' ' > plain-oneline/$f.txt;
    rm $f;
done

mkdir parsed-fictree
for f in plain-oneline/*.txt; do
    o=${f/plain-oneline}
    echo $f - parsed-fictree${o%txt}conllu;
    cat $f | udapy -s read.Sentences udpipe.Cs resegment=1 online=1 model=czech-fictree-ud-2.12-230717 > parsed-fictree${o%txt}conllu;
done

cat parsed-fictree/*conllu > generated/all-auto-fictree.conllu
./tools/eval.py --verbose generated/all-gold.conllu generated/all-auto-fictree.conllu > generated/score-fictree.txt
