#!/bin/bash

./catSemkol.sh   | awk -F";" '{ if (( $1 == "") && ( $9 ~ "2012") && ($47 == "") ) { print ; } }'  | wc -l

./catSemkol.sh   | awk -F";" '{ if (( $1 == "" )) { print ; } }'  | cut -d";" -f3,7,8,9,66 | wc -l


