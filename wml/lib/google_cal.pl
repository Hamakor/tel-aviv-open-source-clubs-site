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
    (map {
            my $year = $_;
            +{
                'id' => "w2l-$year",
                'url' => "w2l-$year.html",
                't_match' => ".*",
                'no_header' => 1,
                'series' => sub { my $s = shift; return ($s eq "w2l-$year") },
            }
        }
        (2005 .. 2008)
    ),
    (map {
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
    } (2003 .. 2008)),
);

# This is a temporary hack until everything is a method call.
my $date_pres_man = Date::Presentations::Manager->new(
    LecturesData::get_params(),
    'streams' => \@streams,
    );

$date_pres_man->calc_lectures_flat();

$date_pres_man->process_all_lectures();

$date_pres_man->syndicate_to_google_calendar(
    {
        url => 'http://www.google.com/calendar/feeds/9g7qee2bk12j3r1eq04t5okf5c%40group.calendar.google.com/private-0d560b10ed9d26f1bea565a5d2b8312c/basic',
        username => "shlomif\@gmail.com",
        location => "Schreiber (Maths & CS) 008, Tel Aviv University",
    }
);

1;

