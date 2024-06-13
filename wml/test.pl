#!/usr/bin/perl

use strict;
use warnings;

use Term::ANSIColor qw/ color /;

use Path::Tiny qw/ cwd path tempdir tempfile /;

if ( system("cd lib && perl render_lectures.pl") )
{
    die "Errors in running the program";
}

my @lines = path("lib/lectures_dest/rss.xml")->lines_utf8();
my ($pub_date) = ( grep { m{^<pubDate>.*</pubDate>\n?$} } @lines );
my ($last_build_date) =
    ( grep { m{^<lastBuildDate>.*</lastBuildDate>\n?$} } @lines );

my @lines_to_change = path("lib/lectures_dest.good/rss.xml")->lines_utf8();
my $count           = 0;
@lines_to_change = (
    map { ( m{^<pubDate>.*</pubDate>\n?$} && ( !$count++ ) ) ? $pub_date : $_ }
        @lines_to_change );
@lines_to_change =
    ( map { m{^<lastBuildDate>.*</lastBuildDate>\n?$} ? $last_build_date : $_ }
        @lines_to_change );
path("lib/lectures_dest.good/rss.xml")->spew_utf8(@lines_to_change);

my $ret = system("diff -u -r lib/lectures_dest.good lib/lectures_dest");

if ( !$ret )
{
    print color('bold blue');
    print "Success!";
    print color('reset');
    print "\n";
}
else
{
    print color('bold red');
    print "There are differences!";
    print color('reset');
    print "\n";
}
exit($ret);
