#!/usr/bin/perl

#die erste datei ist die mitgliederliste, die zweite datei ist die csv datei mit den kontodaten
#aufruf: perl readkontocsv.pl mitgliederdaten.csv überweisungen.csv
unless((-e $ARGV[0]) or (-e $ARGV[1])) {
	exit(1);
}


open(fh,"<", $ARGV[1]);
@file = <fh>;
close(fh);

my $iBetrag = 0;
my $iZweck = 0;
my $iZahlender = 0;
$_ = shift @file;
@columnNames = split/;/;
for(my $i = 0; $i < scalar @columnNames;$i++) {
	$_ = $columnNames[$i];
	if(m/Betrag/) {
		$iBetrag = $i;
	}
	if(m/Verwendungszweck/) {
		$iZweck = $i;
	}
	if(m/Zahlungs/) {
		$iZahlender = $i;
	}
}

#jeder eintrag eine zeile
foreach(@file) {
	@Spalten = split/;/;
	#überprüfung ob beitragshöhe erreicht wurde:
	$Spalten[$iBetrag]=~s/,/./;
	$Spalten[$iBetrag]=~s/"//g;
#	print $Spalten[$iBetrag];
	if($Spalten[$iBetrag]>= 36)
	{
		$Spalten[$iZweck]=~s/"//g;
		$eintrag = `perl getvorname.pl $ARGV[0] "$Spalten[$iZweck]"`;
		if($eintrag eq "")
		{
			$Spalten[$iZahlender]=~s/"//g;
			$eintrag = `perl getvorname.pl $ARGV[0] "$Spalten[$iZahlender]"`;
		}
		print $eintrag;
	}
}
