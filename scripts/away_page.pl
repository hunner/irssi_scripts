#!/usr/bin/perl -w

use strict;
use Irssi;
use Mail::Sendmail;

my $mailserver = 'smtp.aoeu.com';
my $mailuser = 'mailuser';
my $mailpassword = 'mailpassword';

sub away_hilight_page {
    my ($dest, $text, $stripped) = @_;
    my $server = $dest->{server};
    my $nick = Irssi::parse_special('$;');
    my $pager = '503xxxxxxx@vtext.com';

    return if (!$server || !($dest->{level} & MSGLEVEL_HILIGHT)); # || ($dest->{level} & (MSGLEVEL_NOTICES|MSGLEVEL_SNOTES|MSGLEVEL_CTCPS|MSGLEVEL_ACTIONS|MSGLEVEL_JOINS|MSGLEVEL_PARTS|MSGLEVEL_QUITS|MSGLEVEL_KICKS|MSGLEVEL_MODES|MSGLEVEL_TOPICS|MSGLEVEL_WALLOPS|MSGLEVEL_INVITES|MSGLEVEL_NICKS|MSGLEVEL_DCC|MSGLEVEL_DCCMSGS|MSGLEVEL_CLIENTNOTICE|MSGLEVEL_CLIENTERROR)));

    if ($server->{usermode_away}) {
        if ($dest->{target} =~ /^#(please|ignore|these)$/) { return; }
        #print $text;
        $text =~ s/([\*\+\^\$])/\\$1/g;
        $text =~ /g<\/\s+([A-Za-z]+)g\d\/\d\/:(.+)$/;
        #print "Text: $1 is $2;";
        print "Sending sms\n";
        my %mail = ( To      => $pager,
                     From    => 'hunner@irc',
                     Message => "[$nick\@$dest->{target}] $text"
        );
        $mail{server} = $mailserver;
        $mail{auth} = { user => $mailuser, password => $mailpassword, method => "", required => 0 };
        sendmail(%mail) or die $mail::sendmail::error;
    }
}

Irssi::signal_add_last('print text', 'away_hilight_page');
