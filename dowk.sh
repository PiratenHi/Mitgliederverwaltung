#!/bin/bash
WK=$1

bash filterwk.sh semkol_20120203.csv ${WK} > wk/wk_${WK}.csv
csv2ods --encoding=UTF-8 -d";" -i wk/wk_${WK}.csv -o wk/wk_${WK}.ods

