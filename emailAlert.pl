#!/usr/bin/perl
use strict;
use warnings;
use Email::Send::SMTP::Gmail;

my $threshold = 90;
my $email = $ENV{'GMAIL_EMAIL'}; # Your Gmail from environment variable
my $password = $ENV{'GMAIL_PASSWORD'}; # Your password from environment variable

# Execute the 'df' command and store the output
my @df_output = `df --output=pcent,target`;

# Create a Gmail object
my ($mail) = Email::Send::SMTP::Gmail->new(-smtp=>'smtp.gmail.com', -login=>$email, -pass=>$password);

# Parse each line of output
for my $line (@df_output) {
    if ($line =~ /(\d+)% (.*)/) {
        my $usage = $1;
        my $mount_point = $2;

        # If usage is above threshold, send an email
        if ($usage > $threshold) {
            my $message = "WARNING: Disk usage on $mount_point is $usage%";
            $mail->send(-to=>$email, -subject=>'Disk Usage Warning', -body=>$message);
        }
    }
}

$mail->bye;
