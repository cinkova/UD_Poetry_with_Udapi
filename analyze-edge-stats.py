#!/usr/bin/env python3
import sys
from collections import Counter, defaultdict

p_counts = defaultdict(lambda: Counter())
g_counts = defaultdict(lambda: Counter())

DEPRELS = "PreGenNmon nmod amod nsubj obj obl obl:arg".split()

for line in sys.stdin:
    if line[0] == '#':
        continue
    p_ord, pp_ord, p_deprel, g_ord, gp_ord, g_deprel, parent_match, pregennmon = line.rstrip("\n").split("\t")

    if p_ord:
        edge_len = int(p_ord) - int(pp_ord)
        p_counts[g_deprel][edge_len] += 1
        if ':' in g_deprel:
            p_counts[g_deprel.split(':')[0]][edge_len] += 1
        if pregennmon:
            p_counts['PreGenNmon'][edge_len] += 1
            
    if g_ord:
        edge_len = int(g_ord) - int(gp_ord)
        g_counts[g_deprel][edge_len] += 1
        if ':' in g_deprel:
            p_counts[g_deprel.split(':')[0]][edge_len] += 1
        if pregennmon:
            g_counts['PreGenNmon'][edge_len] += 1

print("#deprel\tlength\tauto_count\tgold_count")
for deprel in DEPRELS:
    lens = sorted(list(set(p_counts[deprel].keys()).union(g_counts[deprel].keys())))
    for l in lens:        
        print(f"{deprel}\t{l}\t{p_counts[deprel][l]}\t{g_counts[deprel][l]}")
