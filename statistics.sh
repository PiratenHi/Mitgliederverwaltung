#!/bin/bash

#./catSemkol.sh   | awk -F";" '{ if (( $1 == "") && ( $9 ~ "2012") ) { print ; } }'  | wc -l

#./catSemkol.sh   | awk -F";" '{ if (( $1 == "" )) { print ; } }' | wc -l

./sql "select count(*) from ungesperrte"
./sql "select count(*) from ungesperrte where Beitrag = '2012'"
