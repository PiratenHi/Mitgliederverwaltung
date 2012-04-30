./catSemkol.sh \
 | awk -F";" '{ if ($1 == "Sperre") { print; } if (( $1 == "" ) && ( $3 != "") ) { print ; } }' \
 | cut -d";" -f 3,9 \
 | sed -e 's/"//g;s/2012/-1/g' \
 | awk -F";" '{ if ($2 == "-1") {print;} if ($2 != "-1") {print $1 ";0"} }' 
 
