#!/usr/bin/perl

$from_address = '';
$to_address = '';
$mail_host = 'smtp.example.net';
$username = '';
$password = "PASSWORD";
$port = 465;
$connection_type="STARTTLS"; #can also be "STARTTLS"
$auth_type = 'CRAM-MD5'; # oder PLAIN, LOGIN, CRAM-MD5#
$helo = $mail_host;# oder "mail.example.net";