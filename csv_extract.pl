#!/usr/bin/perl

use MIME::QuotedPrint::Perl;
use v5.10.1;
use Encode;

my %plzort;
open FILE, "</media/truecrypt1/Schatten/nds-plz.csv";
while (<FILE>) {
  s/\"//g;
  s/\n//g;
  s/\r//g;
  ($lk,$feld2,$feld3,$feld4,$plz1) = split (",",$_);
  $plzort{$plz1} = $lk;
}
close FILE;

my $normalBeitrag = 4;

my %plzwk;
open FILE, "</media/truecrypt1/Schatten/plz_wahlkreise.csv";
while (<FILE>) {
  s/\"//g;
  s/\n//g;
  s/\r//g;
  ($wk,$feld2,$plz2) = split (";",$_);
  $plzwk{$plz2} = $wk;
}
close FILE;

$quelle="O";


while (<>) {
  $kontakt = "N";
  $beitrag = 1;
  s/\n//g;
  s/\r//g;
  if (/^Vorname;Name/)  {
    $quelle = "F";
    $beitrag = $normalBeitrag;
    next;
  }
  
  ($vname,$nname,$str,$plz,$ort,$land,$landkreis,$tel,$mail,$geburt,$staat,$minderung,$datumantrag,$datumheute,$quelle) = split ";", $_;
  if ($minderung =~ /NEIN/ ) {
    $beitrag = $normalBeitrag;
  }
  if ($minderung =~ /3/ ) {
    $beitrag = $normalBeitrag;
  }
  if ($minderung =~ /4/ ) {
    $beitrag = $normalBeitrag;
  }
  if ($minderung =~ /N/ ) {
    $beitrag = $normalBeitrag;
  }
  $plz =~ s/"//g;

  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  $year += 1900;
  $mon++;

  $line = ";$quelle;;$staat;;;$vname;$nname;;$beitrag;;;;;;$str;;$plz;$ort;;;$plzwk{$plz};Deutschland;;;;;;$geburt;;$land;$plzort{$plz};DE-NI;;;;$datumantrag;$datumheute;$mday.$mon.$year;;;;;;;;;;;;;;;;;;;;$tel;;;;;;;$mail;;;$kontakt;W;;;;;;;;;;;;;A\n";

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
  if ($beitrag == $normalBeitrag) {
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

  say "sending mail for $vname $nname $mail";

  open MAIL, '|curl -n --insecure --ssl-reqd --mail-from "jason.peper@piraten-nds.de" --mail-rcpt "jason.peper@piraten-nds.de" --mail-rcpt "'.$mail.'" --url smtps://mail.piraten-nds.de:465 -s -T -';
  
  say MAIL 'From: Mitgliederverwaltung (Jason Peper) <jason.peper@piraten-nds.de>';
  say MAIL "To: $mail";
  #say MAIL "Content-Type: text/plain; charset=ISO-8859-15";
  say MAIL "Content-Type: text/plain; charset=UTF-8";
  say MAIL "Subject: Dein Mitgliedsantrag";
  say MAIL "";
  say MAIL $text;
}

