#!/bin/bash

./csv_extract.pl import_online.csv
mv import_online.csv import/import_online_$(date +"%Y-%m-%d").csv
