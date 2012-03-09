#!/usr/bin/perl

use v5.10.1;

#es weden listen mit allen bekannten vornamen und nachnamen und mitgliedsnummern erstellt
$_ = `perl filtergeneric.pl $ARGV[0] Vorname . Vorname`;
s/"//g;
chomp();
@Vornamen= split/;/;
$_ = `perl filtergeneric.pl $ARGV[0] Nachname . Nachname`;
s/"//g;
chomp();
@Nachnamen= split/;/;
$_   = `perl filtergeneric.pl $ARGV[0] Mitgliedsnummer . Mitgliedsnummer`;
s/"//g;
chomp();
@Nummern = split/;/;


#der parameter $ARGV[1] gibt entweder die zu öffnende/durchsuchende inputdatei an, oder sie enthält den string der durchsucht werden soll
if(-e $ARGV[1]) {
	$_ = `cat $ARGV[1]`;
}
else {
	$_ = $ARGV[1];
}

#nachdem alle daten vorliegen durchsucht die folgende schleife die daten nach vornamen und nachnamen sowie möglicherweise vorhandenen mitgliedsnummern
for($i = 0; $i < scalar @Nachnamen; $i++)
{
	if((m/$Vornamen[$i]/i)and($Vornamen[$i] ne ""))
	{
		if((m/$Nachnamen[$i]/i)and($Nachnamen[$i] ne ""))
		{
			say $Vornamen[$i] . " " . $Nachnamen[$i];
		}
	}

	if((m/$Nummern[$i]/)and($Nummern[$i] ne ""))
	{
		say $Nummern[$i];
	}
}

