#!/usr/bin/perl

use strict;
use warnings;

use Date::Presentations::Manager;

my $date_pres_man = Date::Presentations::Manager->get_man();

$date_pres_man->rss_feed()->save($date_pres_man->dest_dir() . "/rss.xml");

open STYLE, ">", ($date_pres_man->dest_dir() . "/style.css");
print STYLE <<EOF;
body { background-color : white ; background-image : url(pics/backtux.gif) }
h1 { text-align : center }
td.c { text-align : center }
hr { height : 4px }
EOF
close (STYLE);

1;

