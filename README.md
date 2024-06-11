[![GloBI Review by Elton](../../actions/workflows/review.yml/badge.svg)](../../actions/workflows/review.yml)

[select-bee-interactions.sh](select-bee-interactions.sh) helps to select bee only biotic interactions from verbatim interactions indexed by GloBI using Nomer's support for DiscoverLife Bee Checklist [1,2].

Two examples are included that demonstrate the outcomes of running this script against GloBI Interpreted Data Products v0.6 and v0.7 [3,4] in [2023-08-25](examples/2023-08-25) and [2024-06-07](examples/2024-06-07) respectively. 

This includes [`bees-only-interactions.tsv.gz`](examples/2024-06-07/bees-only-interactions.tsv.gz) as generated by running:

```
../select-bee-interactions.sh\
 | gzip\
 > bees-only-interactions.tsv.gz
```

For each example, a GloBI index configuration (e.g., [globi.json](examples/2024-06-07/globi.json)) was created to enable an automated data review of this specific subset of GloBI-indexed biotic interactions. Please inspect the [GitHub Actions configuration](.github/workflows/review.yml) if you'd like to learn more about this automated review process. 


## References

[1]  Ascher, J. S. and J. Pickering. 2024. Discover Life bee species guide and world checklist (Hymenoptera: Apoidea: Anthophila). http://www.discoverlife.org/mp/20q?guide=Apoidea_species. 

[2] Poelen, J. H. (ed . ) . (2024). Nomer Corpus of Taxonomic Resources hash://sha256/83617875e84bb8ae7ac2a257ad50eb8e82d8935d975f465b8ee8f3a803f72b48 hash://md5/c639d7e3fcd5603f6c48e9d5e6c49672 (0.24) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.11105453

[3] GloBI Community. (2023). Global Biotic Interactions: Interpreted Data Products hash://md5/89797a5a325ac5c50990581689718edf hash://sha256/946178b36c3ea2f2daa105ad244cf5d6cd236ec8c99956616557cf4e6666545b (0.6) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.8284068

[4] GloBI Community. (2024). Global Biotic Interactions: Interpreted Data Products hash://md5/946f7666667d60657dc89d9af8ffb909 hash://sha256/4e83d2daee05a4fa91819d58259ee58ffc5a29ec37aa7e84fd5ffbb2f92aa5b8 (0.7) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.11552565 
