#!/usr/bin/perl

use v5.10.1;


unless((defined $ARGV[0])or(defined $ARGV[1]))#exit if no arguments are given
{
	say "error, not enough arguments.";
	say "USAGE: filename plz";
	exit(2);
}

unless(-e $ARGV[0])
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

foreach(@columnNames)# searching the correct column number
{
	if(m/^"PLZ"$/)
	{
		$columnNumber = $i;
	}
	$i++;
}


foreach(@file)
{
	chomp();#remove the newline an the end of the line
	@line = split/;/;

	if($line[$columnNumber]=~m/$ARGV[1]/)
	{
		say join(";", @line); #prints the output on screen
	}
}
