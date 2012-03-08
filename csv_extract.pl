#!/usr/bin/perl

use MIME::QuotedPrint::Perl;

my %plzort;
open FILE, "</media/truecrypt1/Schatten/nds-plz.csv";
while (<FILE>) {
  s/\n//g;
  s/\r//g;
  ($lk,$feld2,$feld3,$feld4,$plz1) = split (",",$_);
  $plzort{$plz1} = $lk;
}
close FILE;

my %plzwk;
open FILE, "</media/truecrypt1/Schatten/plz_wahlkreise.csv";
while (<FILE>) {
  s/\n//g;
  s/\r//g;
  ($wk,$feld2,$plz2) = split (";",$_);
  $plzwk{$plz2} = $wk;
#  print "$wk - $plz2 \n";
}
close FILE;

$quelle="\"O\"";

$kontakt = "N";
$beitrag = 1;

while (<>) {
  
  s/\n//g;
  s/\r//g;
  if (/^"Vorname";"Name"/)  {
    $quelle = "\"F\"";
    $beitrag = 3;
    next;
  }
  
  ($vname,$nname,$str,$plz,$ort,$land,$landkreis,$tel,$mail,$geburt,$staat,$minderung,$datumantrag,$datumheute,$quelle) = split ";", $_;
  if ($minderung =~ /NEIN/ ) {
    $beitrag = 3;
  }
  if ($minderung =~ /3/ ) {
    $beitrag = 3;
  }
  $plz =~ s/"//g;

  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  $year += 1900;
  $mon++;

  $line = ";$quelle;;$staat;;;$vname;$nname;;$beitrag;;;;;;$str;;$plz;$ort;;;$plzwk{$plz};\"Deutschland\";;;;;;$geburt;;$land;$plzort{$plz};\"DE-NI\";;;;$datumantrag;$datumheute;\"$mday.$mon.$year\";;;;;;;;;;;;;;;;;;;;$tel;;;;;;;$mail;;;$kontakt;;;;;;;;;;;;;;\"U\"\n";

  open FILE, ">>/media/truecrypt1/Schatten/import/import.csv";
  print FILE $line;
  close FILE;

  $kv = $plzort{$plz};
  $kv =~ s/[\W]/_/g;

  open FILE, ">>/media/truecrypt1/Schatten/import/import_" . $kv . ".csv";
  print FILE $line;
  close FILE;
  my $text;
  my $filename;
  if ($beitrag == 3) {
    $filename = "/media/truecrypt1/Schatten/mitglied_voll.txt";
  } else {
    $filename = "/media/truecrypt1/Schatten/mitglied_ermaessigt.txt";
  }
  open ANSCHREIBEN, "<$filename";
  while (<ANSCHREIBEN>) {
    $text .= $_;
  }
  $text =~ s/VORNAME/$vname/g;
  $beitragsteil = $beitrag*(13-$mon);
  $text =~ s/BEITRAGSTEIL/$beitragsteil/g;

  system "thunderbird -compose \"preselectid=id5,to=$mail,subject='Dein Mitgliedsantrag',body='$text'\"";
}

