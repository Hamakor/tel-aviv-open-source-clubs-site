#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Encode;

binmode STDOUT, ":utf8";

my $html = join("", <>);

$html = decode("utf8", $html);

$html =~ s{<a href="([^"]+)">(.*?)</a>}{$2 (|הלינק|$1|סלינק|)}g;

$html =~ s{<p>}{\n}g;
$html =~ s{</p>}{\n}g;

$html =~ s{\n{2,}}{\n\n}g;

$html =~ s{\A\n+}{};
$html =~ s{\n+\z}{\n};

print $html;
