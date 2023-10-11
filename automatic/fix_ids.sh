#!/bin/bash

udapy read.Conllu files='!*.conllu' \
  util.Eval tree='root.sent_id = root.document.meta["loaded_from"].replace(".conllu", "_") + root.sent_id' \
  write.Conllu overwrite=1
