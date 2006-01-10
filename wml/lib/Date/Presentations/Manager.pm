package Date::Presentations::Manager;

use strict;
use warnings;

use base 'Date::Presentations::Manager::Base';

use Data::Dumper;
use POSIX qw(mktime strftime);
use XML::RSS;

use Date::Presentations::Manager::Stream::Results;

# TODO :
# Remove dest_dir eventually - the manager should not handle the output
__PACKAGE__->mk_accessors(qw(
    base_url
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
        if ((grep { ($_ eq "all") || ($_ =~ m/^$pattern$/) } @$topics) &&
            (! ($is_header && $file->{'no_header'})) &&
            (! ($is_past && $file->{'future_only'})) &&
            (exists($file->{'year'}) ? ($file->{'year'} == $spec->{'year'}) : 1)
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

sub get_lecture_num_field
{
    my ($self, $lecture) = @_;
    my $series = $lecture->{'series'};
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

sub get_lecturer_field
{
    my ($self, $lecture) = @_;

    my $lecturer_record = $self->get_lecturer_record($lecture);

    # Generate the lecturer field

    my $lecturer_field;
    my $name_render_type = $lecturer_record->{'name_render_type'};
    if ($name_render_type eq "email")
    {
        if (!defined($lecturer_record->{'email'}))
        {
            die "Unknown email for lecturer '" . $self->get_lecturer_id($lecture) . "'";
        }
        $lecturer_field = "<a href=\"mailto:" . $lecturer_record->{'email'} . 
        "\">" . $lecturer_record->{'name'} . "</a>";
    }
    elsif ($name_render_type eq "plain")
    {
        $lecturer_field = $lecturer_record->{'name'};
    }
    elsif ($name_render_type eq "homepage")
    {
        $lecturer_field = "<a href=\"". $lecturer_record->{'homepage'} . "\">".
            $lecturer_record->{'name'} . "</a>";
    }
    else
    {
        die ("Unknown lecturer's name_render_type field for " . 
            "lecturer '" . $self->get_lecturer_id($lecture) . "'");
    }

    return $lecturer_field;
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

sub process_lecture
{
    my $self = shift;
    my $lecture = shift;

    my @fields;

    push @fields, $self->get_lecture_num_field($lecture);
    push @fields, $self->get_subject_field($lecture);
    push @fields, $self->get_lecturer_field($lecture);
    push @fields, $self->get_date_field($lecture);
    # Generate the comments field
    push @fields, $self->get_comments_field($lecture);


    # TODO: Remove later.
    my $lecturer_record = $self->get_lecturer_record($lecture);


    # Generate the date field
    
    my ($date_day, $date_month, $date_year) = split(m!/!, $self->get_lecture_date($lecture));

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

    if ($self->is_future())
    {
        my $lecture_url = $lecture->{'url'};
        if ($lecture_url !~ /^http:/)
        {
            $lecture_url = $self->base_url()."/$lecture_url";
        }

        # assuming meetings start at 18:30
        my $date_time = 
            mktime(0, 30, 18, $date_day, $date_month-1, $date_year-1900);
        
        $self->rss_feed()->add_item(
            'title' => $lecture->{'s'},
            (map { $_ => $self->base_url() } (qw(permaLink link))),
            'enclosure' => { 'url' => $lecture_url, },
            'description' => $lecture->{'comments'},
            'author' => $lecturer_record->{'name'},
            'pubDate' => scalar(localtime($date_time)),
            'category' => "Meetings",
        );
    }


    my $rendered_lecture = 
        "<tr>\n" . 
        join("", 
            map 
                {
                    $_ = (ref($_) eq "HASH") ? $_ : { 'text' => $_, 'td-params' => "", };
                    "<td" . $_->{'td-params'} . ">\n" . 
                    $_->{'text'} . "\n</td>\n" 
                } @fields
             ) 
        . "</tr>\n";

    $self->print_files(
        { 
            'topics' => $lecture->{'t'},
            'past' => (! $self->is_future()),
            'year' => $date_year,
        },
        $rendered_lecture
    );
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
        $self->series_indexes()->{$lecture->{'series'}}++;
    }
}


1;

