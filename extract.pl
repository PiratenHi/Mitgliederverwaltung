#!/usr/bin/perl

use MIME::QuotedPrint::Perl;

$kontakt = "N";
$beitrag = 1;

while (<>) {
  $_ = decode_qp($_);

  if (/<p /) {
    next;
  }
  
  s/\n//g;

  if (/E-Mail: /) {
    s/E-Mail: //;
    $mail = $_;
  }

  if (/Vorname, Name: /) {
    s/Vorname, Name: //;
    ($vname, $nname) = split / /, $_, 2;
  }
  
  if (/Vorname:/) {
    s/Vorname: //;
    $vname = $_;
  }
  
  if (/Nachname:/) {
    s/Nachname: //;
    $nname = $_;
  }
  
  if (/Geburtsdatum: /) {
    s/Geburtsdatum: //;
    $geburt = $_;
  }
  
  if (/Staatsangeh.*rigkeit: /) {
    s/Staatsangeh.*rigkeit: //;
    $staat = $_;
  }
  
  if (/Strasse: /) {
    s/Strasse: //;
    $str = $_;
  }
  
  if (/Bundesland: /) {
    s/Bundesland: //;
    $land = $_;
  }
  
  if (/Tel.: /) {
    s/Tel.: //;
    $tel = $_;
  }
  
  if (/Betragswunsch: Normaler /) {
    s///;
    $beitrag = 4;
  }
  
  if (/PLZ, Ort: /) {
    s/PLZ, Ort: //;
    s/[\W]/ /;
    ($plz, $ort) = split;
    $plz =~ s/[^0-9]//;
  }
  
  if (/PLZ: /) {
    s/PLZ: //;
    $plz = $_;
  }
  
  if (/Ort: /) {
    s/Ort: //;
    $ort = $_;
  }
  
  if (/Piraten treffen: Ich/) {
    $kontakt = "J";
  }
  
}

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon++;
$quelle = "O";
# $line = ";O;;$staat;;;$vname;$nname;;$beitrag;;;;;;$str;;$plz;$ort;;;;Deutschland;;;;;;$geburt;;$land;$plzort{$plz};DE-NI;;;;heute;$mday.$mon.$year;$mday.$mon.$year;;;;;;;;;;;;;;;;;;;;$tel;;;;;;;$mail;;;$kontakt;;;;;;;;;;;;;;U\n";
$datumheute = "$mday.$mon.$year";
$datumantrag = $datumheute;
$line = "$vname;$nname;$str;$plz;$ort;$land;;$tel;$mail;$geburt;$staat;$beitrag;$datumantrag;$datumheute;$quelle\n";

open FILE, ">>/media/truecrypt1/Schatten/import_online.csv";
print FILE $line;
close FILE;



