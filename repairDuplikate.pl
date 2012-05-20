#!/usr/bin/perl

while (<>) {
  chomp;
  ($id,$vorname,$nachname) = split (";");  
  print "$vorname $nachname\n";
}
