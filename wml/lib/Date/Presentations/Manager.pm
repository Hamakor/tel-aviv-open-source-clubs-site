package Date::Presentations::Manager;

use strict;
use warnings;

use base 'Date::Presentations::Manager::Base';

use Data::Dumper;
use POSIX qw(mktime strftime);
use XML::RSS;
use DateTime;
use Template;
use utf8;

use Date::Presentations::Manager::Stream::Results;

use Carp;

# TODO :
# Remove dest_dir eventually - the manager should not handle the output
__PACKAGE__->mk_accessors(qw(
    base_url
    _calendar
    group_id
    is_future
    lectures_flat
    num_lectures_in_group
    rss_feed
    series_indexes
    stream_specs
    stream_results
    strict_flag
    this_day
    this_month
    this_year
    webmaster_email
));

my @data_fields = (qw(
    lecturer_aliases
    subject_render_callbacks
    lecturers
    series_map
    topics_map
    topic_aliases
    lectures
));

__PACKAGE__->mk_accessors(@data_fields);

use LecturesData;

sub calc_this_time
{
    my $self = shift;

    my @this_time = localtime(time());
    $self->this_day($this_time[3]);
    $self->this_month($this_time[4]+1);
    $self->this_year($this_time[5]+1900);
}

sub _initialize
{
    my $self = shift;

    my (%args) = @_;

    $self->series_indexes({});
    $self->stream_results({});

    $self->stream_specs($args{'streams'}) or
        die "Undefined arg \"streams\"!";

    foreach my $s (@{$self->stream_specs()})
    {
        $self->stream_results()->{$s->{'id'}} =
            Date::Presentations::Manager::Stream::Results->new();
    }
    $self->group_id(1);
    $self->num_lectures_in_group(20);
    $self->strict_flag(1);
    $self->is_future(0);
    # TODO : make sure base_url is initialized from the arguments.
    $self->base_url("http://www.cs.tau.ac.il/telux/");

    $self->webmaster_email("taux\@cs.tau.ac.il");

    my $rss_feed = XML::RSS->new('version' => "2.0");
    $rss_feed->channel(
        'title' => "Future Telux Lectures",
        'link' => $self->base_url(),
        'language' => "en-us",
        'description' => "Tel Aviv Linux Club (Telux) Future Lectures",
        'rating' => '(PICS-1.1 "http://www.classify.org/safesurf/" 1 r (SS~~000 1))',
        'copyright' => "Copyright 2005, Tel Aviv Linux Club",
        'pubDate' => (scalar(localtime())),
        'lastBuildDate' => (scalar(localtime())),
        'docs' => "http://blogs.law.harvard.edu/tech/rss",
        (map {
            $_ => $self->webmaster_email(),
        } (qw(managingEditor webMaster))),
        'ttl' => "360",
        'generator' => "Perl and XML::RSS",
    );

    $self->rss_feed($rss_feed);

    $self->_calendar([]);

    foreach my $field (@data_fields)
    {
        if (!exists($args{$field}))
        {
            die "You did not specify the required field \"$field\"";
        }
        $self->set($field, $args{$field});
    }

    return 0;
}

sub get_lecture_struct
{
    my $self = shift;
    my ($lecture, $lect_idx, $year) = (@_);

    my %lecture_copy = %$lecture;
    foreach my $field (qw(d t l s))
    {
        if (!exists($lecture_copy{$field}))
        {
            my $d = Data::Dumper->new([$lecture], ["\$lecture"]);
            my $lect_dump = $d->Dump();

            die "Field '${field}' is not present in lecture No. " .
                "$lect_idx of the year $year. Dump Follows:\n$lect_dump";

        }
    }

    my $topics = ((ref($lecture->{'t'}) eq "ARRAY") ? $lecture->{'t'} : [ $lecture->{'t'}]);
    my @processed_topics;
    foreach my $a_topic (@$topics)
    {
        my $real_topic = $a_topic;
        if (!exists($self->topics_map()->{$a_topic}))
        {
            if (exists($self->topic_aliases()->{$a_topic}))
            {
                $real_topic = $self->topic_aliases()->{$a_topic};
            }
            else
            {
                die "Topic '${a_topic}' mentioned in lecture " .
                    "$lecture->{'s'} is not registered.";
            }
        }
        if (!exists($self->topics_map()->{$real_topic}))
        {
            die "Topic '${a_topic} -> ${real_topic}' mentioned in lecture " .
                "$lecture->{'s'} is not registered.";
        }
        push @processed_topics, $real_topic;
    }
    $lecture_copy{'t'} = \@processed_topics;
    $lecture_copy{'d'} .= "/$year" if ($lecture_copy{'d'} =~ /^\d+\/\d+$/);
    if (!exists($lecture_copy{'comments'}))
    {
        $lecture_copy{'comments'} = "";
    }
    if (!exists($lecture_copy{'series'}))
    {
        $lecture_copy{'series'} = "default";
    }
    $self->series_indexes()->{$lecture_copy{'series'}} = 1;
    return \%lecture_copy;
}

sub calc_lectures_flat
{
    my $self = shift;

    my @lectures_flat;

    $self->calc_this_time();

    foreach my $year (sort { $a <=> $b } keys(%{$self->lectures()}))
    {
        my $lect_idx = 0;
        foreach my $lecture (@{$self->lectures()->{$year}})
        {
            push @lectures_flat,
                $self->get_lecture_struct(
                    $lecture,
                    $lect_idx++,
                    $year
                );
        }
    }
    $self->lectures_flat(\@lectures_flat);
}


sub print_files
{
    my $self = shift;

    my $spec = shift;

    my $topics = $spec->{'topics'} || [ "all" ];
    my $is_header = $spec->{'header'};
    my $is_past = $spec->{'past'};

    if (ref($topics) eq "")
    {
        $topics = [ $topics ];
    }
    elsif (@$topics == 0)
    {
        $topics = [ "none" ];
    }

    foreach my $file (@{$self->stream_specs()})
    {
        my $pattern = $file->{'t_match'};
        my $is_series = $file->{'series'} || sub { 1 };
        if ((grep { ($_ eq "all") || ($_ =~ m/^$pattern$/) } @$topics) &&
            (! ($is_header && $file->{'no_header'})) &&
            (! ($is_past && $file->{'future_only'})) &&
            (exists($file->{'year'}) ?
                ($file->{'year'} == $spec->{'year'}) :
                1
            ) &&
            ($is_series->($spec->{'series'}))
           )
        {
            $self->stream_results()->{$file->{'id'}}->insert(
                join("", (map { (ref($_) eq "CODE" ? $_->($file) : $_) } @_))
            );
        }
    }
}

sub get_idx_in_series
{
    my ($self, $lecture) = @_;
    return $self->series_indexes()->{$lecture->{'series'}};
}

sub get_lecture_series
{
    my ($self, $lecture) = @_;
    return $lecture->{'series'};
}

sub get_lecture_num_field
{
    my ($self, $lecture) = @_;
    my $series = $self->get_lecture_series($lecture);
    my $series_handle = $self->series_map()->{$series};
    if (exists($lecture->{'sub-series'}))
    {
        $series_handle = $self->series_map->{$series}->{'sub-series'}->{$lecture->{'sub-series'}};
    }
    my $lecture_num_template = $series_handle->{'lecture_num_template'};
    return $lecture_num_template->(
        $self->get_idx_in_series($lecture),
        'strict' => $self->strict_flag()
        );
}

sub get_lecturer_id
{
    my ($self, $lecture) = @_;

    my $lecturer_id = $lecture->{'l'};

    $lecturer_id =
        (exists($self->lecturer_aliases()->{$lecturer_id}) ?
            $self->lecturer_aliases->{$lecturer_id} :
            $lecturer_id
        );

    if (!exists($self->lecturers()->{$lecturer_id}))
    {
        die "Unknown lecturer ID '$lecturer_id' in lecture of date " . $lecture->{'d'};
    }

    return $lecturer_id;
}

sub get_lecturer_record
{
    my ($self, $lecture) = @_;

    return $self->lecturers()->{$self->get_lecturer_id($lecture)};
}

sub get_subject_field
{
    my ($self, $lecture) = @_;

    # Generate the subject
    my $lecturer_record = $self->get_lecturer_record($lecture);

    if (!exists($lecturer_record->{'subject_render'}))
    {
        my $d = Data::Dumper->new([$lecturer_record], ["\$lecturer_record"]);
        my $lecturer_dump = $d->Dump();

        die "No subject_render for lecturer. Dump Follows:\n$lecturer_dump";
    }

    my $subject_render_text =
        (exists($lecture->{'subject_render'}) ?
            $lecture->{'subject_render'} :
            $lecturer_record->{'subject_render'}
        );

    my $subject_render;

    # if (ref($subject_render_text) eq "CODE")
    if (0)
    {
        $subject_render = $subject_render_text;
    }
    elsif (exists($self->subject_render_callbacks()->{$subject_render_text}))
    {
        $subject_render = $self->subject_render_callbacks()->{$subject_render_text};
    }
    else
    {
        die "Unknown Subject Render '$subject_render_text'!\n";
    }

    return
        $subject_render->(
            $lecture,
            $self->get_idx_in_series($lecture),
        );
}

sub get_lecturer_name
{
    my ($self, $lecture) = @_;
    return $self->get_lecturer_record($lecture)->{'name'};
}

sub get_lecturer_field
{
    my ($self, $lecture) = @_;

    my $lecturer_record = $self->get_lecturer_record($lecture);
    my $name = $self->get_lecturer_name($lecture);

    # Generate the lecturer field

    my $lecturer_field;
    my $name_render_type = $lecturer_record->{'name_render_type'};
    if ($name_render_type eq "email")
    {
        if (!defined($lecturer_record->{'email'}))
        {
            die "Unknown email for lecturer '" . $self->get_lecturer_id($lecture) . "'";
        }
        return "<a href=\"mailto:" . $lecturer_record->{'email'} .
        "\">$name</a>";
    }
    elsif ($name_render_type eq "plain")
    {
        return $name;
    }
    elsif ($name_render_type eq "homepage")
    {
        return "<a href=\"". $lecturer_record->{'homepage'} . "\">$name</a>";
    }
    else
    {
        die ("Unknown lecturer's name_render_type field for " .
            "lecturer '" . $self->get_lecturer_id($lecture) . "'");
    }
}

sub get_lecture_date
{
    my ($self, $lecture) = @_;
    return $lecture->{'d'};
}

sub get_date_field
{
    my ($self, $lecture) = @_;

    return $self->get_lecture_date($lecture);
}

sub get_comments_field
{
    my ($self, $lecture) = @_;

    return $lecture->{'comments'};
}

sub get_lecture_date_time
{
    my ($self, $lecture) = @_;
    my ($date_day, $date_month, $date_year) = $self->get_lecture_dmy($lecture);
    # assuming meetings start at 18:30
    return mktime(0, 30, 18, $date_day, $date_month-1, $date_year-1900);
}

sub add_rss_item
{
    my ($self, $lecture) = @_;

    my $lecture_url = $lecture->{'url'};
    if ($lecture_url !~ /^http:/)
    {
        $lecture_url = $self->base_url()."/$lecture_url";
    }

    $self->rss_feed()->add_item(
        'title' => $lecture->{'s'},
        (map { $_ => $self->base_url() } (qw(permaLink link))),
        'enclosure' => { 'url' => $lecture_url, },
        'description' => $self->get_comments_field($lecture),
        'author' => $self->get_lecturer_name($lecture),
        'pubDate' => scalar(localtime($self->get_lecture_date_time($lecture))),
        'category' => "Meetings",
    );

    push @{$self->_calendar()},
        {
            url => $lecture_url,
            title => $lecture->{s},
            'time' => $self->get_lecture_date_time($lecture),
            'lecturer' => $self->get_lecturer_name($lecture),
        };
}

sub get_lecture_dmy
{
    my ($self, $lecture) = @_;
    return split(m!/!, $self->get_lecture_date($lecture));
}

sub get_lecture_DateTime
{
    my ($self, $lecture) = @_;

    my ($date_day, $date_month, $date_year) = $self->get_lecture_dmy($lecture);

    return DateTime->new(
        year => $date_year,
        month => $date_month,
        day => $date_day,
        hour => "18",
        minute => 0,
    );
}

sub get_lecture_url
{
    my ($self, $lecture) = @_;

    return $self->get_lecture_DateTime($lecture)->strftime(
        "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_%d_%B_%Y"
    );
}

sub get_lecture_year
{
    my ($self, $lecture) = @_;
    my ($d, $m, $y) = $self->get_lecture_dmy($lecture);
    return $y;
}

sub update_is_future
{
    my ($self, $lecture) = @_;

    my ($date_day, $date_month, $date_year) = $self->get_lecture_dmy($lecture);

    if (! $self->is_future() )
    {
        my $cmp_val =
            (($date_year <=> $self->this_year()) ||
            ($date_month <=> $self->this_month()) ||
            ($date_day <=> $self->this_day()));

        if ($cmp_val >= 0)
        {
            # TODO: Add a way to separate between future and past.
            $self->is_future(1);
        }
    }
}
sub render_field
{
    my ($self, $lecture, $field) = @_;
    $field =
        (ref($field) eq "HASH") ?
            $field :
            { 'text' => $field, 'td-params' => "", }
            ;
    return "<td" . $field->{'td-params'} . ">\n" .
        $field->{'text'} . "\n</td>\n";
}

sub get_fields_list
{
    return [qw(lecture_num subject lecturer date comments)];
}

sub get_fields
{
    my $self = shift;
    my $lecture = shift;

    return
    [
        map
        {
            $self->can("get_".$_."_field")->($self, $lecture)
        }
        @{$self->get_fields_list()}
    ];
}

sub render_lecture
{
    my ($self, $lecture) = @_;

    return
        "<tr>\n" .
        join("",
            (map { $self->render_field($lecture, $_) } @{$self->get_fields($lecture)})
        ) .
        "</tr>\n";
}

sub process_lecture
{
    my $self = shift;
    my $lecture = shift;


    $self->update_is_future($lecture);

    if ($self->is_future())
    {
        $self->add_rss_item($lecture);
        $self->_output_lecture_publicity($lecture);
    }

    $self->print_files(
        {
            'topics' => $lecture->{'t'},
            'past' => (! $self->is_future()),
            'year' => $self->get_lecture_year($lecture),
            'series' => $self->get_lecture_series($lecture),
        },
        $self->render_lecture($lecture),
    );
}

sub gen_lecture_publicity
{
    my ($self, $lecture) = @_;

    my $lang = 'he';

    return {
        $lang => $self->_gen_lecture_publicity_for_lang($lecture, $lang),
    };
}

sub _gen_lecture_publicity_for_lang
{
    my ($self, $lecture, $lang) = @_;

    if ($lang ne "he")
    {
        Carp::confess "Wrong lang '$lang'!";
    }

    my $template_text = <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="[% lang %]">
<head>
<title>Telux Announcement</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
body { direction : rtl; text-align : right; }
</style>
</head>
<body>

<p>
<a href="[% obj.club_url() %]">[% obj.club_name(lang) %]</a>
ייפגש שוב כדי לשמוע את
<a href="[% lect_url %]">הרצאתו של
ירון מאירי (Sawyer) אודות "Moose, מערכת תכנות מונחה העצמים לשפת פרל (למתחילים)"</a>.
ההרצאה תתקיים ביום ראשון, 17 בינואר 2010, בשעה 18:00 (שימו לב לשינוי בשעה משנה שעברה),
באולם הולצבלט, מס' 007 במסדרון הבניינים למדעים מדויקים (שימו לב לשינוי במיקום משנה שעברה) באוניברסיטת תל אביב. פרטים נוספים, מפות להגעה וכיוצא בזה, ניתן למצוא
<a href="[% obj.club_url() %]">באתר</a>
<a href="[% lect_url %]">ובוויקי</a>.
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

    my $template = Template->new({});

    my $xhtml = "";
    $template->process(
        \$template_text,
        {
            obj => $self,
            lect => $lecture,
            lang => $lang,
            lect_url => $self->get_lecture_url($lecture),
        },
        \$xhtml,
    )
        or Carp::confess $template->error();

    return {xhtml => $xhtml};
}

sub club_url
{
    return "http://tel.foss.org.il/";
}

sub club_name
{
    my ($self, $lang) = @_;

    return (
        ($lang eq "he")
        ? "מועדון הקוד הפתוח התל-אביבי (תלוקס)"
        : "The Tel Aviv Open Source Club (TelFOSS)"
    );
}

sub _output_lecture_publicity
{
    my ($self, $lecture) = @_;


}

sub process_all_lectures
{
    my $self = shift;
    foreach my $lecture (@{$self->lectures_flat()})
    {
        $self->process_lecture($lecture);
    }
    continue
    {
        $self->series_indexes()->{$self->get_lecture_series($lecture)}++;
    }
}

sub syndicate_to_google_calendar
{
    my $self = shift;
    my $args = shift;

    my $calendar_url = $args->{'url'};
    my $username = $args->{'username'};
    my $location = $args->{'location'};

    print "Please Enter Your Google Password:\n";
    my $password = <>;
    chomp($password);

    require Net::Google::Calendar;

    my $cal = Net::Google::Calendar->new(url => $calendar_url);

    $cal->login($username, $password);

    foreach my $event (@{$self->_calendar()})
    {
        my $day_start = DateTime->from_epoch( epoch => $event->{time});
        my $day_end = DateTime->from_epoch( epoch => $event->{time});

        $day_start->set(hour => 0, minute => 0, second => 0);
        $day_end->set(hour => 23, minute => 59, second => 0);

        if ($cal->get_events(
                'start-min' => $day_start, 'start-max' => $day_end
            )
        )
        {
            # Do nothing - already populated.
        }
        else
        {
            my $start = DateTime->from_epoch( epoch => $event->{'time'} );
            my $end = $start + DateTime::Duration->new(hours => 2);

            my $entry = Net::Google::Calendar::Entry->new();

            $entry->title($event->{'title'});
            $entry->content('OSDClub Tel Aviv Lecture');
            $entry->location($location);
            $entry->status('confirmed');
            $entry->transparency('opaque');
            $entry->visibility('public');
            $entry->when($start, $end);

            $cal->add_entry(
                $entry
            );
        }
    }
}

# Not working yet.
sub generate_publicity_files
{
    my $self = shift;
    my $args = shift;

    my $dest_dir = $args->{'dest_dir'};

    foreach my $event (@{$self->_calendar()})
    {
        my $day = DateTime->from_epoch( epoch => $event->{time});
    }
}
1;

