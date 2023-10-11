from udapi.core.block import Block

class FixAutomatic(Block):

    def process_tree(self, root):
        if root.sent_id == "0083-0001-0001-0000-0015-0000_10":
            if root.descendants[49].form == 'chvílí':
                root.descendants[49].form = 'chvíli'
            if root.descendants[40].form == '.':
                root.descendants[40].remove()
            root.text = None
