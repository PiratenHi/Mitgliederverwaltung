#!/usr/bin/perl

use DBI;
use v5.10.1;

my $dbargs = {AutoCommit => 0, PrintError => 1};
my $dbh = DBI->connect("dbi:SQLite:dbname=db.sq3", "", "", $dbargs);

open(DATEI, "<", $ARGV[0]);
	my @datei = <DATEI>;
close(DATEI);

$_ = shift @datei;

$i=0;
chomp ();
$firstline = $_;
@columnNames = split/;/;

foreach(@columnNames) { # searching the correct column number
	$Numbers{$_} = $i;
	$i++;
}

if ($Numbers{'Vorname'} eq "" || $Numbers{'Nachname'} eq "" ) {
  say "I need Vorname AND Nachname to work";
  exit 1;
}

foreach(@datei) {
  chomp ();
  @line = split/;/;
	  $line[scalar @columnNames - 1] = "" if($line[scalar @columnNames - 1] eq "");#some absurd construct to guarantee the right number of columns
  foreach (keys %Numbers) {
    if ($_ =~ /Vorname/ || $_ =~ /Nachname/ ) {
    } else {
      say "$line[$Numbers{'Vorname'}] $line[$Numbers{'Nachname'}]  - $_ = $line[$Numbers{$_}]";
      $sql = "UPDATE semkol SET \"".$_."\" = \"".$line[$Numbers{$_}]."\"";
      $sql .= " WHERE Vorname = \"".$line[$Numbers{'Vorname'}]. "\"";
      $sql .= " AND Nachname = \"" .$line[$Numbers{'Nachname'}]."\"";
      $sql .= " AND Mitgliedsnummer = \"\"";
      $sql .= " AND Sperre = \"\"";
      $sql .= " ;";
      $sth = $dbh->prepare($sql);
      $rv = $sth->execute;
      if ($dbh->err()) { die "$DBI::errstr\n"; }
      say " result: ". $sth->rows. " changed";
    }
  }


}

$dbh->commit();
