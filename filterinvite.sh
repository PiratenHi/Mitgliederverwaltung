cat $1  \
 | awk -F";" '{ if (( $1 == "" || $1 == "U") && ( $9 != "") && ($47 == "") ) { print ; } }' \
 | cut -d";" -f3,7,8,9,66
 
 #sqlite -separator ";" db.sq3 "select Mitgliedsnummer,Vorname,Nachname,beitrag,email_1 from ungesperrte where invitecode = '' AND beitrag != ''"
