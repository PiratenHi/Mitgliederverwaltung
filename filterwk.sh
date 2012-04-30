./catSemkol.sh \
 | awk -F";" '{ if ($1 == "Sperre") { print; } if (( $1 == "" || $1 == "U") && ( $22 == '"$1"') ) { print ; } }' \
 | ./cutKV.sh
