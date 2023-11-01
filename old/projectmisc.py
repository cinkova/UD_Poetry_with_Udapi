"""ProjectMisc block to project attributes from MISC via word alignment"""
from udapi.core.block import Block


class ProjectMisc(Block):

    def __init__(self, gold_zone='gold', attr='PreGenNmod', **kwargs):
        super().__init__(**kwargs)
        self.gold_zone = gold_zone
        self.attr = attr

    def process_tree(self, tree):
        gold_tree = tree.bundle.get_tree(self.gold_zone)
        if tree == gold_tree:
            return
        g_nodes = gold_tree.descendants
        for p_node in tree.descendants:
            if p_node.misc["Align"]:
                g_node = g_nodes[int(p_node.misc["Align"]) - 1]
                if g_node.misc[self.attr]:
                    p_node.misc[self.attr] = 1
