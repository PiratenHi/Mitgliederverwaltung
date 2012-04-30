#!/bin/bash

# SQL="/usr/bin/sqlite3 db.sq3"

oldIFS=$IFS

IFS="
"

LKS="Ammerland
Aurich
Celle
Cloppenburg
Cuxhaven
Diepholz
Emsland
Friesland
Gifhorn
Goslar
Göttingen
Grafschaft Bentheim
Hamburg
Hameln-Pyrmont
Hannover
Harburg
Heidekreis
Helmstedt
Hildesheim
Holzminden
Leer
Lüchow-Dannenberg
Lüneburg
München
Nienburg (Weser)
Northeim
Oldenburg
Osnabrück
Osterholz
Osterode am Harz
Peine
Region Hannover
Rotenburg (Wümme)
Schaumburg
Stade
Stadt Braunschweig
Stadt Delmenhorst
Stadt Emden
Stadt Oldenburg
Stadt Osnabrück
Stadt Salzgitter
Stadt Wilhelmshaven
Stadt Wolfsburg
Uelzen
Vechta
Verden
Wesermarsch
Wittmund
Wolfenbüttel"

for LK in $LKS ; do
  IFS=$oldIFS
  LKout=$(echo $LK | sed -e "s/ /_/g")
  #echo "| $LK"
  #echo "| {{:NDS:Vorlage:Landkreise in NDS|${LKout}_gesamt}}"
  #echo "|-"
  echo "{{:NDS:Vorlage:LandkreisZeile|${LK}|${LKout}}}"

done

