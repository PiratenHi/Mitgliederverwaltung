#!/usr/bin/perl

use v5.10.1;


unless((defined $ARGV[0])or(defined $ARGV[1]))#exit if no arguments are given
{
	say "error, not enough arguments. If some infromation unknown, use undef";
	say "USAGE: filename mitgliedsnumber vorname nachname invite code";
	exit(2);
}

unless((-e $ARGV[0]))
{
	print "no such file or directory\n";
	exit(3);
}

open(fh, "<", $ARGV[0]);
	my @file = <fh>;#read whole file at once, each list entry is one line
close(fh);

my %plzwk;
open FILE, "</media/truecrypt1/Schatten/plz_wahlkreise.csv";
while (<FILE>) {
  s/\n//g;
  s/\r//g;
  ($wk,$feld2,$plz2) = split (";",$_);
  $plzwk{$plz2} = $wk;
}
close FILE;

$_ = shift @file;

$firstline = $_;
@columnNames = split/;/;

my $columnNumber = 0;
my $i = 0;

my %Numbers;

foreach(@columnNames) { # searching the correct column number
	s/"//g;
	$Numbers{$_} = $i;
	$i++;
}

my $linenumber = 1;
my @error;
$i = 0;

  foreach(@file) {
	  $linenumber++;
	  chomp();
	  @line = split/;/;
	  $line[scalar @columnNames - 1] = "" if($line[scalar @columnNames - 1] eq "");#some absurd construct to guarantee the right number of columns

    my $plz = $line[$Numbers{'PLZ'}];
	    my $insert = $plzwk{$plz};
	    $insert =~ s/"//g;
	    if ($insert != "") {
  	    if ($line[$Numbers{'Lwahlkreis'}] != $insert) {
	        say STDERR "$line[$Numbers{'PLZ'}] \t".$line[$Numbers{'Lwahlkreis'}]." \t!= ".$insert ."\t$line[$Numbers{'Ort'}]";
	      }
		    $line[$Numbers{'Lwahlkreis'}] = "$insert";
		    chomp($line[$Numbers{'Lwahlkreis'}]);
		    $file[$i] =  join(";", @line);
		  } else {
		    say STDERR "$plz not found";
		  }
		  #say $bezahlt[2];

	  $i++;
	}

print $firstline;
foreach (@file) {
  say;
}

# say "errors:";
foreach (@error) {
  say "X;$_";
}
