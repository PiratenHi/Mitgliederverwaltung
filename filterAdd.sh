./catSemkol.sh | awk -F";" '{ if (( $83 == "A") ) { print ; } }' 

