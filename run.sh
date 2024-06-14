#!/bin/bash

#./select_bee_interactions.sh hash://md5/a18697d59e5f6756c22d8c4a1346685e\
# | gzip\
# > examples/2023-08-25/bees-only-interactions.tsv.gz

./select_bee_interactions.sh hash://md5/7e11573d83b2bac6425ee2482c4d73bc\
 | gzip\
  > examples/2024-06-07/bees-only-interactions.tsv.gz 

