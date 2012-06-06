#!/usr/bin/perl
use OpenOffice::OODoc;
use DBI;
use v5.10.1;
use warnings;
use Getopt::Long;

my $databasefile="commandline_neu.sqlite";      #Datenbank
my $table = "semkol";    #Tabelle
my $column = "Landkreis";     #Spalte wo der KV drin steht
my $showcolumns = "`Sperre`,`Antrag`,`Mitgliedsnummer`,`Stabü`,`Anrede`,`Titel`,`Vorname`,`Nachname`,`Beitrag`,`M_Beitrag`,`e1`,`e2`,`e3`,`Zahl2011`,`PoRüL`,`Straße_1`,`Straße_2`,`PLZ`,`Ort`,`Ortsteil`,`Wahlkreis`,`Lwahlkreis`,`Land`,`abweichende_Strasse_1`,`abweichende_Strasse_2`,`abw._PLZ`,`abw._Ort`,`abw._Land`,`geburts_datum_TT.MM.JJJJ`,`Beruf`,`Bundesland`,`Landkreis`,`Landesverband`,`Bezirksverband`,`Kreisverband`,`Ortsverband`,`Eingang Antrag`,`eintritts_datum`,`start_date`,`austritts_datum`,`wegzugsdatum`,`ma angefordert`,`ma versendet`,`ma gedruckt`,`ma an`,`bemerkungsfeld`,`2007`,`2008`,`2009`,`2010`,`2011`,`abweichender_Konto_Inhaber`,`Kontonummer`,`BLZ`,`IBAN`,`BIC`,`Einzug`,`Telefon_1`,`Telefon_2`,`Telefon_3`,`Fax 1`,`Fax 2`,`Fax 3`,`EmRüL`,`eMail_1`,`eMail_2`,`eMail_3`,`mKmPvO`,`Chaser`,`e4`,`Membership`,`e5`,`e6`,`e7`,`e8`,`e9`,`e10`,`e11`,`e12`,`e13`,`e14`,`Update`";      #Spalten, die exportiert werden sollen (kommagetrennt)
my $num_cols = 85;          # Anzahl an spalten fuer die ods datei
my $globalattach = "AND Sperre=''"; #Zusatz zum SQL qry, hier nur ungesperrte
my @headlines = ("Sperre","Antrag","Mitgliedsnummer","Stabü","Anrede","Titel","Vorname","Nachname","Beitrag","","","","","Zahl2011","PoRüL","Straße_1","Straße_2","PLZ","Ort","Ortsteil","Wahlkreis","Lwahlkreis","Land","abweichende_Strasse_1","abweichende_Strasse_2","abw._PLZ","abw._Ort","abw._Land","geburts_datum_TT.MM.JJJJ","Beruf","Bundesland","Landkreis","Landesverband","Bezirksverband","Kreisverband","Ortsverband","Eingang Antrag","eintritts_datum","start_date","austritts_datum","wegzugsdatum","ma angefordert","ma versendet","ma gedruckt","ma an","bemerkungsfeld","2007","2008","2009","2010","2011","abweichender_Konto_Inhaber","Kontonummer","BLZ","IBAN","BIC","Einzug","Telefon_1","Telefon_2","Telefon_3","Fax 1","Fax 2","Fax 3","EmRüL","eMail_1","eMail_2","eMail_3","mKmPvO","Chaser","","Membership","","","","","","","","","","","Update"); #Spaltenueberschriften/erste zeile
my $sheet    = 0;
my $dbargs = {AutoCommit => 0, PrintError => 1};

if(not(defined($ARGV[0])) || $ARGV[0] eq "--help" || $ARGV[0] eq "help" || $ARGV[0] eq "?" || $ARGV[0] eq "-h") {
print "Usage: createods.pl [options]

Optionen
    -k          Kreisverband. Koennen auch mehrere sein, dann mit Komma trennen
    -f          Zieldatei (example.ods)
    -d          SQLite-Datenbankdatei
    -t          Tabelle in der DB

    Alles weitere (welche Spalten sollen mit welcher Ueberschrift sollen uebernommen werden usw.) direkt in der Datei einstellen!\n";
    exit 1;
}

# Argumente uebernehmen

GetOptions('k=s' => \$kv, 'f=s' => \$file, 'd:s' => \$databasefile, 't:s' => \$table);

# Verbindung zur MitgliederDB herstellen
my $dbh = DBI->connect("dbi:SQLite:dbname=" . $databasefile, "", "", $dbargs);

#ods erstellen
my $doc = odfDocument(file => $file, create => 'spreadsheet');


@kvs=split(",",$kv);

# Anzahl der Records abfragen, um die Tabelle zu erweitern
$sql2 = "SELECT COUNT(*) FROM " . $table;
my $attach = " WHERE (" . $column . " LIKE '" . $kvs[0] . "'";
shift(@kvs);    
foreach $this_kv (@kvs) {
$attach .= " OR " . $column . " LIKE '" . $this_kv . "'";
}
$attach .=') ' . $globalattach;
$sql2 .=$attach;
$sth2 = $dbh->prepare($sql2);
$sth2->execute();
my @firstq = $sth2->fetchrow_array();
$num_rows=$firstq[0];

# Tabelle erweitern
$num_rows=$num_rows+2;
$doc->expandTable($sheet, $num_rows, $num_cols);
my $headcol=0;
    foreach (@headlines) {
     $doc->updateCell($sheet, 0, $headcol, $_);
     $headcol++;
     }
# Daten aus der Mitgliederdb abfragen
$sql = "SELECT $showcolumns FROM " . $table;
$sql .= $attach;
$sth = $dbh->prepare($sql);
$sth->execute();

# Daten in die ODS uebergeben
my $row=1;
while ( @data = $sth->fetchrow_array() ) 
{
my $col=0;
    $row++;
    foreach (@data) {
     $doc->updateCell($sheet, $row, $col, $_);
     $col++;
     }
}


#ods datei speichern
$doc->save();



