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

open(bezahlt, "<", $ARGV[1]);
	my @bezahltfile = <bezahlt>;#read whole file at once, each list entry is one line
close(bezahlt);

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

# say "looking for $ARGV[2] $ARGV[3]";

my @error;
foreach (@bezahltfile) {
  chomp;
  my @bezahlt = split/;/;
  #say @bezahlt;
  my $i = 0;
  my $found = 0;
  foreach(@file) {
    #say $i;
	  $linenumber++;
	  chomp();#remove the newline an the end of the line
	  @line = split/;/;
	  $line[scalar @columnNames - 1] = "" if($line[scalar @columnNames - 1] eq "");#some absurd construct to guarantee the right number of columns
	  if (
	      ($line[$Numbers{'Vorname'}] eq $bezahlt[1]) and 
	      ($line[$Numbers{'Nachname'}] eq $bezahlt[2]) and
	      ($line[$Numbers{'Mitgliedsnummer'}] == $bezahlt[0]) ) {
	    $found = 1;
		  $line[$Numbers{'Beitrag'}] = "\"$bezahlt[3]\"";
		  chomp($line[$Numbers{'Beitrag'}]);
		  $file[$i] =  join(";", @line);
		  #say $bezahlt[2];
	  } else {
	  }
	  $i++;
	}
	if ($found == 0) {
	  push @error, join(";", @bezahlt);
	}
}

print $firstline;
foreach (@file) {
  say;
}

# say "errors:";
foreach (@error) {
  say "X;$_";
}
