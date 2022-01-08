#!/usr/bin/env sh
mongoimport --db=dsdbt \
  --collection=stations \
  --file=/dsdb/data/bike-stations.json \
  --jsonArray \
  --username=root \
  --password=toor \
  --authenticationDatabase=admin