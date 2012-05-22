#!/usr/bin/perl
#use lib "/opt/local/lib/perl5/site_perl/5.12.3/darwin-multi-2level";
#use lib "/opt/local/lib/perl5/site_perl/5.12.3";

use warnings;
use DBI;
use v5.12.3;
use Getopt::Long;
my $kv;
our $row;
GetOptions('k=s' => \$kv);

my $dbh = DBI->connect("DBI:CSV:f_dir=.;csv_eol=\n;", undef, undef, {csv_sep_char     => ";"});


$dbh->{'csv_tables'}->{'kreisverbaende'} = { 'file' => 'kreisverbaende.csv'};


my $sth = $dbh->prepare("SELECT * FROM kreisverbaende WHERE kv LIKE ?");

$sth->execute($kv);

$row = $sth->fetchrow_hashref;
#print("createods.pl ", $row->{'lk'}); 
#print $row;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year = $year+1900;
$mon = $mon+1;
if ($mon < 10)
{ $mon = "0".$mon; }
print "Mailversendung gestartet fuer den KV " . $row->{'kv'} . " (" . $row->{'name'} . ")\n^c zum Abbrechen (ca. 30 sekunden Zeit, je nach Mitgliederanzahl)";
$sth->finish();
#print("./createods.pl -k ", $row->{'lk'}, " -f lk_" , $row->{'lk'} , "_" , $year , $mon , $mday , ".ods"); 
system("./createods.pl -k " . $row->{'lk'} . " -f lk_" . $row->{'lk'} . "_" . $year . $mon . $mday . ".ods"); 


#print("./autosend.pl --to ", $row->{'mail'}, " --pgp ", $row->{'pgp'}, " lk_" , $row->{'lk'} , "_" , $year , $mon , $mday , ".ods"); 
system("./autosend.pl --to " . $row->{'mail'} . " --text \"Hallo " . $row->{'name'} . ",\n Im Anhang bekommst du die aktuellen Mitgliedsdaten f??r den KV " . $row->{'kv'} . "\n --\nMitgliederverwaltung\n\" --subject \"Aktuelle Mitgliederdaten KV " . $row->{'kv'} . "\" --pgp " . $row->{'pgp'} . " lk_" . $row->{'lk'} . "_" . $year . $mon . $mday . ".ods"); 
#print 'autosend.pl --to ' . $row->{'mail'} . ' --pgp  ' . $row->{'pgp'};