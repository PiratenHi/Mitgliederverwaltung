sqlite -separator ";" db.sq3 'select Mitgliedsnummer,Vorname,Nachname,straße_1 from ungesperrte' | sort | uniq -d 
