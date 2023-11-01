"""EdgeStats block to print dependency edge statistics for gold and aligned pred trees"""
from udapi.core.basewriter import BaseWriter

class EdgeStats(BaseWriter):

    def __init__(self, gold_zone='gold', pred_zone='auto', misc_attrs='PreGenNmod', **kwargs):
        super().__init__(**kwargs)
        self.gold_zone = gold_zone
        self.pred_zone = pred_zone
        self.attrs = misc_attrs.split(",")

    def print_edge(self, p_node, g_node):
        p_ord, pp_ord, p_deprel, g_ord, gp_ord, g_deprel, parent_match = [""] * 7
        if p_node:
            p_ord, pp_ord, p_deprel = str(p_node.ord), str(p_node.parent.ord), p_node.deprel
        if g_node:
            g_ord, gp_ord, g_deprel = str(g_node.ord), str(g_node.parent.ord), g_node.deprel
            values = [g_node.misc[a] for a in self.attrs]
        else:
            values = ["" for a in self.attrs]
        if p_node and g_node:
            if p_node.parent.misc["Align"] and int(p_node.parent.misc["Align"]) == g_node.parent.ord:
                parent_match = "correct"
            else:
                parent_match = "wrong"
        print("\t".join([p_ord, pp_ord, p_deprel, g_ord, gp_ord, g_deprel, parent_match, *values]))

    def before_process_document(self, document):
        super().before_process_document(document)
        attrs_string = '\t'.join(self.attrs)
        print(f"#{self.pred_zone}.ord\t{self.pred_zone}.parent.ord\t{self.pred_zone}.deprel"
              f"\t{self.gold_zone}.ord\t{self.gold_zone}.parent.ord\t{self.gold_zone}.deprel"
              f"\tparent_match\t{attrs_string}")          

    def process_bundle(self, bundle):
        g_tree = bundle.get_tree(self.gold_zone)
        p_tree = bundle.get_tree(self.pred_zone)
        assert g_tree and p_tree

        g_nodes = [g_tree] + g_tree.descendants
        p_nodes = [p_tree] + p_tree.descendants
        g_to_p = {}
        for p_node in p_tree.descendants:
            if p_node.misc["Align"]:
                g_node = g_nodes[int(p_node.misc["Align"])]
                g_to_p[g_node] = p_node
                self.print_edge(p_node, g_node)
            else:
                self.print_edge(p_node, None)
        for g_node in g_tree.descendants:
            if not g_node in g_to_p:
                self.print_edge(None, g_node)
