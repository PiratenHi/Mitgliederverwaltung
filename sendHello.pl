#!/usr/bin/perl

use MIME::QuotedPrint::Perl;

$vname = $ARGV[0];
$mail  = $ARGV[1];

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
