#!/usr/bin/perl

use strict;
use warnings;

use Date::Presentations::Manager;

use LecturesData;

my @streams = 
(
    {
        'id' => "future",
        'url' => "future.html",
        't_match' => ".*",
        'no_header' => 1,
        'future_only' => 1,
    },
    {
        'id' => "w2l-2005",
        'url' => "w2l-2005.html",
        't_match' => ".*",
        'no_header' => 1,
        'series' => sub { my $s = shift; return ($s eq "w2l-2005") },
    },
    map {
        +{
            'id' => $_,
            'url' => "$_.html",
            't_match' => ".*",
            'no_header' => 1,
            'year' => $_,
            'series' => sub {
                my $s = shift;
                return ($s eq "default");
            },
        },
    } (2003 .. 2006)
);

# This is a temporary hack until everything is a method call.
my $date_pres_man = Date::Presentations::Manager->new(
    LecturesData::get_params(),
    'streams' => \@streams,
    );

$date_pres_man->calc_lectures_flat();

my $dest_dir = "./lectures_dest";

if (! -d $dest_dir)
{
    mkdir($dest_dir);
}

$date_pres_man->process_all_lectures();

foreach my $s (@streams)
{
    open O, ">" , $dest_dir . "/" . $s->{'url'};
    print O @{$date_pres_man->stream_results()->{$s->{'id'}}->get_items()};
    close(O);
}

$date_pres_man->rss_feed()->save($dest_dir. "/rss.xml");

open STYLE, ">", ($dest_dir . "/style.css");
print STYLE <<EOF;
body { background-color : white ; background-image : url(pics/backtux.gif) }
h1 { text-align : center }
td.c { text-align : center }
hr { height : 4px }
EOF
close (STYLE);

1;

