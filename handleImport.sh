#!/bin/bash

# ./csv_extract.pl import_online.csv
# cat semkol_20120203.csv import/import.csv > semkol_temp.csv
echo ".separator ';'
.import import/import.csv semkol" | sqlite db.sq3
# mv semkol_temp.csv semkol_20120203.csv
mv import/import.csv import/import_imported_$(date +"%Y-%m-%d").csv
