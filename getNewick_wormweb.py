#! /Users/semple/miniconda3/bin/python

import json
from json_to_newick_wormweb import json_to_newick
from json_to_newick_wormweb import json_to_table

lineage_file=open("json-celllineage.json","r")

lineage=json.load(lineage_file)
lineage_file.close()

lineageNewick=json_to_newick(lineage)

lineageTbl=json_to_table(lineage)

newick_file=open("lineage_wormweb.nwk","w")
newick_file.write(lineageNewick)
newick_file.close()


table_file=open("lineage_wormweb.tsv","w")
table_file.write(lineageTbl)
table_file.close()
