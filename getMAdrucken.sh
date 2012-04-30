#!/bin/bash

echo "Nummer,Name,Datum,EAN" > MA2.csv

sqlite -separator ";" db.sq3 'select Mitgliedsnummer,Vorname,Nachname,eintritts_datum from ungesperrte where "ma angefordert" like "" AND Beitrag like "2012" AND Mitgliedsnummer not like ""' \
 | awk -F";" '{ printf "%d,%s %s,%s,%07d\n", $1,$2,$3,$4,$1}' >> MA2.csv

DATE=$(date "+%Y-%m-%d_%H-%M")

unix2dos MA2.csv

iconv --from-code=UTF8 --to-code=ISO-8859-15 MA2.csv > MA_${DATE}.csv

# echo sqlite -separator ";" db.sq3 "UPDATE semkol set 'ma angefordert' = \"$DATE\" where 'ma angefordert' like '' AND Beitrag like '2012' AND Mitgliedsnummer not like '';"

sqlite -separator ";" db.sq3 'UPDATE semkol set "ma angefordert" = (select strftime("%d.%m.%Y")) where "ma angefordert" like "" AND Beitrag like "2012" AND Mitgliedsnummer not like "";'
