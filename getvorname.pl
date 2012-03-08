#!/usr/bin/perl

use v5.10.1;

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

$_ = `cat $ARGV[1]`;

for($i = 0; $i < scalar @Nachnamen; $i++)
{
	if((m/$Vornamen[$i]/)and($Vornamen[$i] ne ""))
	{
		if((m/$Nachnamen[$i]/)and($Nachnamen[$i] ne ""))
		{
			say $Vornamen[$i] . " " . $Nachnamen[$i];
		}
	}

	if((m/$Nummern[$i]/)and($Nummern[$i] ne ""))
	{
		say $Nummern[$i];
	}
}

