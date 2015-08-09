#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Test::More tests => 2;
use Test::Differences;

use List::Util qw(first);

use Date::Presentations::Manager;

use LecturesData;

# So we can output the text from the tests as UTF-8
binmode(STDOUT, ":encoding(utf-8)");
binmode(STDERR, ":encoding(utf-8)");

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

my $lecture = first {
    join(",", $date_pres_man->get_lecture_dmy($_)) eq "17,01,2010"
} @{$date_pres_man->lectures_flat()};

# TEST
ok ($lecture, "Found the lecture.");

my $result = $date_pres_man->gen_lecture_publicity($lecture);

# TEST
eq_or_diff(
    $result->{'he'}->{'xhtml'},
    <<"EOF",
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="he">
<head>
<title>Telux Announcement</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
body { direction : rtl; text-align : right; }
</style>
</head>
<body>

<p>
<a href="http://tel.foss.org.il/">מועדון הקוד הפתוח התל-אביבי (תלוקס)</a>
ייפגש שוב כדי לשמוע את
<a href="http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_17_January_2010">הרצאתו של
ירון מאירי (Sawyer) אודות "Moose, מערכת תכנות מונחה העצמים לשפת פרל (למתחילים)"</a>.
ההרצאה תתקיים ביום ראשון, 17 בינואר 2010, בשעה 18:00 (שימו לב לשינוי בשעה משנה שעברה),
באולם הולצבלט, מס' 007 במסדרון הבניינים למדעים מדויקים (שימו לב לשינוי במיקום משנה שעברה) באוניברסיטת תל אביב. פרטים נוספים, מפות להגעה וכיוצא בזה, ניתן למצוא
<a href="http://www.cs.tau.ac.il/telux/">באתר</a>
<a href="http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_17_January_2010">ובוויקי</a>.
הנוכחות בהרצאה היא חינמית ולא נדרשת הרשמה מראש.
</p>

<p>
<a href="http://moose.perl.org/">Moose</a>
הינה מערכת תכנות מונחה-עצמים פוסט-מודרנית לשפה פרל 5. היא נכתבה
מכיוון שההוגה המקורי שלה (סטיבן ליטל) קינא במה שפרל 6 סיפקה
בנוגע לתכנות מונחה עצמים, ולכן במקום לעבור לרובי הוא שקד על פיתוח
מערכת דומה לפרל 5. Moose שאבה השראה מיכולות ה-OOP של שפות רבות
כמו פרל 6, Smalltalk, ליספ, רובי, ג'אווה, OCaml ושפות אחרות כשהיא
נשארת נאמנה לשורשי ה-פרל 5 שלה.
</p>

<p>
ירון מאירי הינו מנהל מערכות ומפתח פרל. הוא מרצה על קוד פתוח, תוכנה חופשית,
אבטחה וסטנדרטים של תכנות. ירון העביר בעבר את
<a href="http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_28_June_2009">ההרצאה
על דגלים אדומים בתכנות עבור שפות עיליות ביותר</a> במועדון התל-אביבי.
</p>

<p>
אנו תמיד מחפשים מרצים שיתנדבו לתת הרצאות בנושאים שונים הקשורים לקוד-פתוח ולמחשבים. במידה שאתם מעוניינים לתת הרצאה, או שיש לכם הצעה להרצאה שמעניינת אתכם, נשמח לשמוע ממכם.
</p>

</body>
</html>
EOF
    "Hebrew XHTML Publicity is OK."
);

