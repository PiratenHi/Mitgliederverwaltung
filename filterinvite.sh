cat $1  \
 | awk -F";" '{ if (( $1 == "" || $1 == "\"U\"") && ( $9 != "") && ($47 == "") ) { print ; } }' \
 | cut -d";" -f3,7,8,9,66
