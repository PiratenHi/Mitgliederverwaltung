./catSemkol.sh | awk -F";" '{ if (( $83 == "U") ) { print ; } }' 

