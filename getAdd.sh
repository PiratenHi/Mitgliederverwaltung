#!/bin/bash

sqlite -separator ";" db.sq3 'select Mitgliedsnummer ,Anrede ,Vorname ,Titel ,Nachname ,Straße_1 ,Land ,PLZ ,Ort ,Telefon_1 ,"Fax 1", eMail_1 ,start_date, Landesverband ,"",Kreisverband ,"",Wahlkreis ,Lwahlkreis ,Landkreis ,"", Bundesland ,"" ,"" ,"StaBü", "geburts_datum_TT.MM.JJJJ" ,"ma angefordert","" ,"ma versendet","" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" , ""  from semkol where "Update" == "A";' \
 | sed -e "s/Niedersachsen/NI/g"
