from udapi.core.block import Block

class FixManual(Block):

    def process_tree(self, root):
        if root.sent_id == "0078-0001-0000-0000-0028-0000_5":
            stoji = root.children[0]
            zde = stoji.create_child(form="Zde", lemma="zde", upos="ADV", xpos="Db-------------", feats="PronType=Dem", deprel="advmod")
            zde.shift_before_subtree(stoji)
            root.text = None
