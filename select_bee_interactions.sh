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
# date: 2024-06-06/2024-06-10
#
# usage:
#   select_bee_interactions [interactions.tsv.gz content id (aka content hash)]    

# example:
#   select_bee_interactions "hash://md5/7e11573d83b2bac6425ee2482c4d73bc"
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

set -x

interactions_2023_08_23_verbatim_release="hash://md5/a18697d59e5f6756c22d8c4a1346685e"
interactions_2024_06_07_verbatim_snapshot="hash://md5/7e11573d83b2bac6425ee2482c4d73bc"
interactions_tsv_gz_hash=${1:-hash://md5/7e11573d83b2bac6425ee2482c4d73bc}


function interactions {
  # prefetch interactions as referenced by their content id
  preston cat --remote https://linker.bio ${interactions_tsv_gz_hash} > /dev/null
  # get the interaction data, and uncompress
  preston cat ${interactions_tsv_gz_hash}\
   | gunzip
}


function header_fields {
  # prints the first linke of the interactions to be used as the header
  # of the original results
  interactions\
   | head -1\
   | tr '\t' '\n'
}

function header {
  # generates header of aligned interaction table
  cat\
   <(interactions | head -1 | tr -d '\n')\
   <(echo -ne "\t")\
   <(echo -e "\tApis mellifera" | nomer append --properties <(schema "sourceTaxonName") --include-header discoverlife | head -n1 | cut -f3- | sed 's/resolved/alignedSourceTaxon/g' | sed 's/relationName/alignedSourceTaxonRelationName/g' | sed -E 's/[.]([a-z])/\U\1/g' | tr -d '\n')\
   <(echo -ne "\t")\
   <(echo -e "\tApis mellifera" | nomer append --properties <(schema "sourceTaxonName") --include-header discoverlife | head -n1 | cut -f3- | sed 's/resolved/alignedTargetTaxon/g' | sed 's/relationName/alignedTargetTaxonRelationName/g' | sed -E 's/[.]([a-z])/\U\1/g') 
}

function find_index_of_field_header {
  # get the column number (if any) for provided input
  header_fields\
   | nl -v 0 -s ':'\
   | grep "$1"\
   | $(echo cut -d':' -f1)\
   | tr -d ' '
}

function number_of_fields {
  # counts the number of columns in the header
  header_fields | wc -l 
}

function schema {
  # generates the input/output nomer schema to configure name alignment
  # for selected interactions.tsv.gz data. 
  field_index=$(find_index_of_field_header "$1")
  echo "$(cat <<_EOF_
nomer.schema.input=[{"column": ${field_index},"type":"name"}]
nomer.schema.output=[{"column": ${field_index},"type":"name"}]
nomer.append.schema.output=[{"column":0,"type":"externalUrl"},{"column": 1,"type":"name"},{"column": 2,"type":"authorship"},{"column": 3,"type":"rank"},{"column": 4,"type":"commonNames"},{"column": 5, "type":"path.kingdom.name"},{"column": 6, "type":"path.kingdom.id"},{"column": 7, "type":"path.kingdom.authorship"},{"column": 8, "type":"path.phylum.name"},{"column": 9, "type":"path.phylum.id"},{"column": 10, "type":"path.phylum.authorship"},{"column":11, "type":"path.class.name"},{"column":12, "type":"path.class.id"},{"column": 13, "type":"path.class.authorship"},{"column":14, "type":"path.order.name"},{"column":15, "type":"path.order.id"},{"column": 16, "type":"path.order.authorship"},{"column":17, "type":"path.family.name"},{"column":18, "type":"path.family.id"},{"column": 19, "type":"path.family.authorship"},{"column":20, "type":"path.subfamily.name"},{"column":21, "type":"path.subfamily.id"},{"column": 22, "type":"path.subfamily.authorship"},{"column":23, "type":"path.tribe.name"},{"column":24, "type":"path.tribe.id"},{"column": 25, "type":"path.tribe.authorship"},{"column":26, "type":"path.subtribe.name"},{"column":27, "type":"path.subtribe.id"},{"column": 28, "type":"path.subtribe.authorship"},{"column":29, "type":"path.genus.name"},{"column":30, "type":"path.genus.id"},{"column": 31, "type":"path.genus.authorship"},{"column":32, "type":"path.subgenus.name"},{"column":33, "type":"path.subgenus.id"},{"column": 34, "type":"path.subgenus.authorship"},{"column":35, "type":"path.species.name"},{"column":36, "type":"path.species.id"},{"column": 37, "type":"path.species.authorship"},{"column":38, "type":"path.subspecies.name"},{"column":39, "type":"path.subspecies.id"},{"column": 40, "type":"path.subspecies.authorship"},{"column":41,"type":"path"},{"column":42,"type":"pathIds"},{"column":43,"type":"pathNames"},{"column":44,"type":"pathAuthorships"},{"column":45,"type":"nameSource"},{"column":46,"type":"nameSourceUrl"},{"column":47,"type":"nameSourceAccessedAt"}]
_EOF_
)"
}


function select_bee_interactions {
   nomer replace --properties <(schema "sourceTaxonName") gbif-parse `# parse taxonomic name to facilitate matching (e.g., Apis mellifera L. -> Apis mellifera)`\
   | nomer replace --properties <(schema "targetTaxonName") gbif-parse\
   | nomer append --properties <(schema "sourceTaxonName") discoverlife `# align provided names with the discoverlife matcher/checklist`\
   | nomer append --properties <(schema "targetTaxonName") discoverlife\
   | grep -v NONE.*NONE `# only include interactions with one or more names known to DiscoverLife bee checklist`\
   | grep -E "Andrenidae|Apidae|Colletidae|Halictidae|Megachilidae|Melittidae|Stenotritidae" `# only include interaction records that mention at least one of the known bee families`
}

cat `# create a file with a header and interactions with bees only`\
 <(header) `# print the header`\
 <(interactions\
 | pv -l\
 | select_bee_interactions `# then append selected bee interactions`\
 )
