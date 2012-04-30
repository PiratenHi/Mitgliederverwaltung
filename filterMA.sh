echo "Nummer,Name,Datum,EAN" > MA.csv
./catSemkol.sh \
 | awk -F";" '{ if (( $1 == "" || $1 == "U") && ( $3 != "")&& ( $9 != "") && ($42 == "") ) { print ; } }' \
 | cut -d";" -f7,8,3,38,42 \
 | sed -e "s/\"//"g \
 | awk -F";" '{ printf "%d,%s %s,%s,%07d\n", $1,$2,$3,$4,$1}' >> MA.csv
