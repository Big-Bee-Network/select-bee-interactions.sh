#!/bin/bash
#
# Compiles a dataset with at least one interacting
# organisms associated with DiscoverLife bee checklist. 
# Note that if a source/target taxon is specified as a higher order
# taxon that *may* be of Apoidea (bee/wasps), they are included also.
# Examples include: Arthropoda, Insecta, Hymenoptera.
#
# also see https://github.com/globalbioticinteractions/globalbioticinteractions/issues/984
#
# Designed to work with Global Biotic Interactions (GloBI, [1]) *interactions.tsv.gz data products [2] 
# 
#
# author: Jorrit H. Poelen
# date: 2024-06-06
#
# usage:
#   select_bee_interactions [interactions.tsv.gz url]    

# example:
#   select_bee_interactions "https://zenodo.org/record/8284068/files/verbatim-interactions.tsv.gz"
#
# expected output:
#   only interaction records involving some name known to Nomer's usage of the DiscoverLife Bee Checklist [3,4]
#
# 
# References
#
# [1] Jorrit H. Poelen, James D. Simons and Chris J. Mungall. (2014). Global Biotic Interactions: An open infrastructure to share and analyze species-interaction datasets. Ecological Informatics. doi: 10.1016/j.ecoinf.2014.08.005.
# [2] GloBI Community. (2023). Global Biotic Interactions: Interpreted Data Products hash://md5/89797a5a325ac5c50990581689718edf hash://sha256/946178b36c3ea2f2daa105ad244cf5d6cd236ec8c99956616557cf4e6666545b (0.6) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.8284068 
# [3] Poelen, J. H. (ed . ) . (2024). Nomer Corpus of Taxonomic Resources hash://sha256/83617875e84bb8ae7ac2a257ad50eb8e82d8935d975f465b8ee8f3a803f72b48 hash://md5/c639d7e3fcd5603f6c48e9d5e6c49672 (0.24) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.11105453 
# [4] Ascher, J. S. and J. Pickering. 2024. Discover Life bee species guide and world checklist (Hymenoptera: Apoidea: Anthophila). http://www.discoverlife.org/mp/20q?guide=Apoidea_species. 


# For local files, please use file urls like: 
#   file:///${PWD}/bees.tsv.gz

interactions_tsv_gz=${1:-"https://zenodo.org/record/8284068/files/verbatim-interactions.tsv.gz"}

function interactions {
  curl --silent -L "${interactions_tsv_gz}"\
   | gunzip
}

function header {
  interactions\
   | head -1\
   | tr '\t' '\n'
}

function find_index_of_field_header {
  header\
   | nl -v 0 -s ':'\
   | grep "$1"\
   | $(echo cut -d':' -f1)\
   | tr -d ' '
}

function number_of_fields {
  header | wc -l 
}

function schema {
  field_index=$(find_index_of_field_header "$1")
  echo "$(cat <<_EOF_
nomer.schema.input=[{"column": ${field_index},"type":"name"}]
nomer.schema.output=[{"column": ${field_index},"type":"name"}]
_EOF_
)"
}


function select_bee_interactions {
   nomer replace --properties <(schema "sourceTaxonName") gbif-parse\
   | nomer replace --properties <(schema "targetTaxonName") gbif-parse\
   | nomer append --properties <(schema "sourceTaxonName") discoverlife\
   | nomer append --properties <(schema "targetTaxonName") discoverlife\
   | grep -v NONE.*NONE\
   | grep -E "Andrenidae|Apidae|Colletidae|Halictidae|Megachilidae|Melittidae|Stenotritidae"\
   | cut -f1-$(number_of_fields)
}

cat\
 <(interactions | head -n1)\
 <(interactions\
 | pv -l\
 | select_bee_interactions\
 )
