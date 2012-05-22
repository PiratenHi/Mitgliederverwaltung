#!/usr/bin/perl
use warnings;
use MIME::Lite;
use Net::SMTP;
#use Net::SMTP_auth;
use Net::SMTP::SSL;
use Getopt::Long;

# only required for @tillzz:
# use lib "/opt/local/lib/perl5/site_perl/5.12.3/darwin-multi-2level";
#//
# init empty vars
our $from_address;
our $to_address;
our $mail_host;
our $username;
our $password;
our $port = 465;
our $auth_type = 'CRAM-MD5'; #PLAIN, CRAM-MD5#
our $helo;
our $subject = "No Subject";
our $text = "No Text";
our $pgp;
our $debug = 0;

# include config file
require "autosend_config.pl";

# print help if required
if(not(defined($ARGV[0])) || $ARGV[0] eq "--help" || $ARGV[0] eq "help" || $ARGV[0] eq "?" || $ARGV[0] eq "-h") {
print "Usage: autosend.pl [options] attachment1 [attachment2 ...]
Given Options will override settings from context.

Options (all options are definable in autosend_config.pl):
    --from      address to send mail From
    --to        recipient
    --server    smtp server
    --user      smtp username
    --helo      server to announce (default: given smtp server)
    --password  smtp server password (warning: if you save it in config file, protect the file!
    --port      smtp server
    --auth      server authentication method. default: CRAM-MD5
    --subject   mail subject
    --text      mail body text
    --pgp       an pgp key id to decrypt the file(s) for\n";
    exit 1;
}

# get args
GetOptions( 'from:s' => \$from_address, 
            'to:s' => \$to_address, 
            'server:s' => \$mail_host, 
            'user:s' => \$username, 
            'helo:s' => \$helo, 
            'password:s' => \$password, 
            'port:s' => \$port, 
            'auth:s' => \$auth_type,
            'subject:s' => \$subject,
            'text:s' => \$text,
            'pgp:s' => \$key,                
            );
            
# print errors if parameters are neither in args not in config file defined

print "no sender given!" if (!$from_address);
print "no recipient given!" if (!$to_address);
print "no smtp username given!" if (!$username);
print "no password given!" if (!$password);
print "no subject given!" if (!$subject);
print "no text given!" if (!$from_address);

# init mail
$MIME::Lite::AUTO_CONTENT_TYPE='true';
$msg = MIME::Lite->new (
  From => $from_address,
  To => $to_address,
  Subject => $subject,
  Type =>'multipart/mixed',
);

# add text to mail
$msg->attach (
  Type => 'TEXT',
  Data => $text
);

# attach files
foreach $file (@ARGV) {
$msg->attach (
#   Type => 'image/png',
   Path => $file,
   Filename => $file,
   Disposition => 'attachment'
);
}

# auth at server and init smtp
#my $smtp = Net::SMTP_auth->new($mail_host, Hello => $helo, Port=>$port, Debug => $debug );
my $smtp = Net::SMTP::SSL->new($mail_host, Hello => $helo, Port=>$port, Debug => $debug );
$smtp->auth( $auth_type, $username , $password ); 

$smtp->mail($from_address);
$smtp->to($to_address);

$smtp -> data();

# encryption
if($key) {
use Crypt::OpenPGP;
my $pgp = Crypt::OpenPGP->new;

#encrypt whole message
my $encrypted = $pgp->encrypt(
    Data   => $msg->as_string(),
    Recipients => $key,
    Armour     => 1,
);
# create second container for encryption
$msg2 = MIME::Lite->new (
  From => $from_address,
  To => $to_address,
  Subject => $subject,
  Type =>'multipart/encrypted; protocol="application/pgp-encrypted"'
);

# attach Version name
$msg2->attach (
   Type => 'application/pgp-encrypted',
   Data => "Version: 1",
   Encoding => '8bit',   
);

# attach encrypted message
$msg2->attach (
   Data => $encrypted,
   Disposition => 'inline',
   Filename => 'encrypted.asc',
   Type => 'application/octet-stream',
   Encoding => '8bit',   
);


# send second container
$smtp -> datasend( $msg2->as_string() );
} else {
$smtp -> datasend( $msg->as_string() );
}
$smtp -> dataend();
$smtp -> quit;