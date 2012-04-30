sqlite db.sq3 'select Mitgliedsnummer,Vorname,Nachname from ungesperrte' | sort | uniq -c | grep -v ' 1 '
