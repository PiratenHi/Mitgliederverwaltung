#!/usr/bin/perl

use v5.10.1;


unless((defined $ARGV[0])or(defined $ARGV[1]))#exit if no arguments are given
{
	say "error, not enough arguments.";
	say "USAGE: filename columnname pattern";
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


foreach(@file)
{
	chomp();#remove the newline an the end of the line
	@line = split/;/;

	if($line[$Numbers{$ARGV[1]}]=~m/$ARGV[2]/)
	{
		if(defined $ARGV[3])#if only some columns for output are needed
		{
			$_ = $ARGV[3];
			my @output = split/;/;
			foreach(@output)
			{
				print $line[$Numbers{$_}].";";
			}
			say "";
		}else
		{
			say join(";", @line); #prints the output on screen
		}
	}
}
