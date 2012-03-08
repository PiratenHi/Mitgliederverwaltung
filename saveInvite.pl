#!/usr/bin/perl

use v5.10.1;


unless((defined $ARGV[0])or(defined $ARGV[1])or(defined $ARGV[2])or(defined $ARGV[3])or(defined $ARGV[4]))#exit if no arguments are given
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

$_ = shift @file;

@columnNames = split/;/;

my $columnNumber = 0;
my $i = 0;

my %Numbers;

foreach(@columnNames)# searching the correct column number
{
	s/"//g;
	$Numbers{$_} = $i;
#	if(m/^"$ARGV[1]"$/)
#	{
#		$columnNumber = $i;
#	}
	$i++;
}


my $linenumber = 1;

# say "looking for $ARGV[2] $ARGV[3]";

foreach(@file)
{
	$linenumber++;
	chomp();#remove the newline an the end of the line
	@line = split/;/;
	$line[scalar @columnNames - 1] = "" if($line[scalar @columnNames - 1] eq "");#some absurd construct to guarantee the right number of columns
	if(
	    ( 
	      ($line[$Numbers{'Vorname'}]=~m/$ARGV[2]/) and 
	      ($line[$Numbers{'Nachname'}]=~m/$ARGV[3]/)
	    ) or 
	    ($line[$Numbers{'Mitgliedsnummer'}]=~m/^$ARGV[1]$/)
	  )
	{
#		say $linenumber . "c". $linenumber;
#		say "< ". join(";", @line);
#		say "---";
		$line[$Numbers{'Invite Code'}] = "\"$ARGV[4]\"";
		chomp($line[$Numbers{'Invite Code'}]);
		say join(";", @line);
	} else {
	  say join(";", @line);
	}
}
