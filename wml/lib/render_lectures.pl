#!/usr/bin/perl -w 

use strict;

use FileHandle;

use Data::Dumper;

use LecturesData;

use POSIX;



my @lectures_flat;

my @this_time = localtime(time());
my ($this_day, $this_month, $this_year) = @this_time[3,4,5];
$this_year += 1900;
$this_month++;
my %series_indexes = ();
foreach my $year (sort { $a <=> $b } keys(%lectures))
{
    my $lect_idx = 0;
    foreach my $lecture (@{$lectures{$year}})
    {
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
            if (!exists($topics_map{$a_topic}))
            {
                if (exists($topic_aliases{$a_topic}))
                {
                    $real_topic = $topic_aliases{$a_topic};
                }
                else
                {
                    die "Topic '${a_topic}' mentioned in lecture " . 
                        "$lecture->{'s'} is not registered.";
                }
            }
            if (!exists($topics_map{$real_topic}))
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
        $series_indexes{$lecture_copy{'series'}} = 1;
        push @lectures_flat, {%lecture_copy };
    }
    continue
    {
        $lect_idx++;
    }
}

my $dest_dir = "./lectures_dest/";
if (! -d $dest_dir)
{
    mkdir($dest_dir);
}

my $group_id = 1;

my $num_lectures_in_group = 20;

my $last_idx_in_group = 20;

my $num_default_lectures = scalar(grep { $_->{'series'} eq 'default' } (@lectures_flat));

sub get_group_indexes
{
    my $group_id = shift;
    my $first_idx = $num_lectures_in_group*($group_id-1)+1;
    my $last_idx = $first_idx+19;

    return ($first_idx, $last_idx);
}

my $get_grouped_file = sub {
    my ($first_idx, $last_idx) = get_group_indexes($group_id);
    $last_idx_in_group = $last_idx;
    return {
        'id' => "grouped",
        'url' => "lectures$group_id.html",
        't_match' => ".*",
        '<title>' => "Haifa Linux Club (Lectures $first_idx-$last_idx)",
        'h1_title' => "Haifa Linux Club - Lectures $first_idx-$last_idx",
        'buffer' => "",
    };
};

my @files = 
(
    {
        'id' => "all",
        'url' => "all.html",
        't_match' => ".*",
        '<title>' => "Haifa Linux Club (All Lectures)",
        'h1_title' => "Haifa Linux Club - All the Lectures",
    },
    {
        'id' => "future",
        'url' => "future.html",
        't_match' => ".*",
        'no_header' => 1,
        'future_only' => 1,
    },
    $get_grouped_file->(),        
);

while (my ($id, $topic) = each(%topics_map))
{
    push @files, 
        {
            'id' => $id,
            'url' => ($topic->{'url'}.".html"),
            't_match' => $id,
            '<title>' => ("Haifa Linux Club (" . $topic->{'title'} . ")"),
            'h1_title' => ("Haifa Linux Club - " . $topic->{'title'}),
        };
}

@files = 
(
    map {
        +{
            'id' => $_,
            'url' => "$_.html",
            't_match' => ".*",
            'no_header' => 1,
            'year' => $_,
        },
    } (2003 .. 2005)
);

my ($grouped_file_idx) = (grep { $files[$_]->{'id'} eq "grouped" } (0 .. $#files));

foreach my $f (@files)
{
    $f->{'buffer'} = "";
}


my $print_files = sub
{
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

    foreach my $file (@files)
    {
        my $pattern = $file->{'t_match'};
        if ((grep { ($_ eq "all") || ($_ =~ m/^$pattern$/) } @$topics) &&
            (! ($is_header && $file->{'no_header'})) &&
            (! ($is_past && $file->{'future_only'})) &&
            (exists($file->{'year'}) ? ($file->{'year'} == $spec->{'year'}) : 1)
           )
        {
            $file->{'buffer'} .= join("", (map { (ref($_) eq "CODE" ? $_->($file) : $_) } @_));
        }
    }
};

my $strict_flag = @ARGV ? shift : 1;

my $get_header = 
    sub { 
        my $file = shift; 
        if (! exists($file->{'<title>'}))
        {
            my $d = Data::Dumper->new([$file], ['$file']);
            print $d->Dump();
            die "Hello";
        }
        
        my $strict = $strict_flag;
        
        return (
            #qq{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">\n},
            ($strict ? 
            qq{<!DOCTYPE html
     PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\n}
            :
            qq{<!DOCTYPE html 
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n}
            ),
            "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">\n",
            "<head>\n", 
            "<title>$file->{'<title>'}</title>\n", 
            "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n",
            ($strict ? qq{<link rel="StyleSheet" href="./style.css" type="text/css" />\n} : ""),
            "</head>\n",
            ($strict ? "<body>" : "<body bgcolor=\"white\" text=\"black\" background=\"pics/backtux.gif\">\n"),
            ($strict ? 
                "<h1>$file->{'h1_title'}</h1>\n" :
                "<div align=\"center\"><h1>$file->{'h1_title'}</h1></div>\n"
            ),
            "<h2>Past Lectures</h2>\n",
            ) ;
    };

sub print_headers
{
    return $print_files->(
        {
            'header' => 1,
        },
        @_
    );
}

&print_headers($get_header);

my $table_headers =  
    "<table border=\"1\">\n" .
    "<tr>\n" .
    join("", map { "<td>$_</td>\n" } ("Lecture Number", "Subject", "Lecturer", "Date", "Comments or Links")) .
    "</tr>\n";

&print_headers($table_headers);
    
my ($lecture);
my $is_future = 0;

my $page_footer = "</table>\n<hr />\n" . 
    "<h3><a href=\"all.html\">All the Lectures</a></h3>\n" .
    "<h3>Other Lectures Sorted by Number</h3>\n" .
    "<ul>\n" . 
        join("", 
            (map 
                { 
                    my ($f, $l) = get_group_indexes($_); 
                    "<li><a href=\"lectures$_.html\">Lectures $f-$l</a></li>\n"
                }
                (1 .. POSIX::ceil($num_default_lectures/20))
            )
        ) . "</ul>\n" .
    "<h3>Other Lectures Sorted by Topic</h3>\n" .
    "<ul>\n" .
        join("", 
            (map
                { 
                    if (!exists($topics_map{$_}))
                    {
                        die "Unknown Topic in \@topics_order : $_!\n";
                    }
                    my $url = (exists($topics_map{$_}{'url'}) ? $topics_map{$_}{'url'} : $_);
                    "<li><a href=\"$url.html\">".($topics_map{$_}->{'name'})."</a></li>\n" 
                } 
                (@topics_order)
            )
        ) .
    "</ul>\n" .
    "<p><a href=\"./\">Back to the club's site</a></p>\n</body>\n</html>\n";

foreach $lecture (@lectures_flat)
{
    my @fields;

    # Generate the lecture number
    my $series = $lecture->{'series'};
    my $idx_in_series = $series_indexes{$series};
    my $series_handle = $series_map{$series};
    if (exists($lecture->{'sub-series'}))
    {
        $series_handle = $series_map{$series}->{'sub-series'}->{$lecture->{'sub-series'}};
    }
    my $lecture_num_template = $series_handle->{'lecture_num_template'};
    push @fields, $lecture_num_template->($idx_in_series, 'strict' => $strict_flag);

    # Generate the subject

    my $lecturer_id = $lecture->{'l'};

    $lecturer_id = 
        (exists($lecturer_aliases{$lecturer_id}) ? 
            $lecturer_aliases{$lecturer_id} :
            $lecturer_id
        );

    if (!exists($lecturers{$lecturer_id}))
    {
        die "Unknown lecturer ID '$lecturer_id' in lecture of date " . $lecture->{'d'};
    }

    my $lecturer_record = $lecturers{$lecturer_id};

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
    elsif (exists($subject_render_callbacks{$subject_render_text}))
    {
        $subject_render = $subject_render_callbacks{$subject_render_text};
    }
    else
    {
        die "Unknown Subject Render '$subject_render_text'!\n";
    }
        
    push @fields, 
        $subject_render->(
            $lecture,
            $idx_in_series
        );

    # Generate the lecturer field

    my $lecturer_field;
    my $name_render_type = $lecturer_record->{'name_render_type'};
    if ($name_render_type eq "email")
    {
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
        die ("Uknown lecturer's name_render_type field for " . 
            "lecturer '$lecturer_id'");
    }

    push @fields, $lecturer_field;
    
    # Generate the date field
    
    my $date = $lecture->{'d'};
    my ($date_day, $date_month, $date_year) = split(m!/!, $date);

    if (! $is_future )
    {
        my $cmp_val =
            (($date_year <=> $this_year) ||
            ($date_month <=> $this_month) ||
            ($date_day <=> $this_day));

        if ($cmp_val >= 0)
        {
            &print_headers(
                "</table>\n",
                "<h2>Future Lectures</h2>\n",
                $table_headers
            );
            $is_future = 1;
        }
    }
        
    
    # $date =~ s{^(\d+)/(\d+)/\d{2}(\d{2})$}{$1/$2/$3};
    
    push @fields, $date;

    # Generate the comments field

    push @fields, $lecture->{'comments'};

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

    $print_files->(
        { 
            'topics' => $lecture->{'t'},
            'past' => (! $is_future),
            'year' => $date_year,
        },
        $rendered_lecture
    );
}
continue
{
    my $series = $lecture->{'series'};
    my $lecture_idx = ($series_indexes{$series}++);
    if (($series eq 'default') && ($lecture_idx == $last_idx_in_group))
    {
        $group_id++;
        if (defined($grouped_file_idx))
        {
            my $f = $files[$grouped_file_idx];
            my $buffer = $f->{'buffer'};
            $buffer .= $page_footer;
            open O, ">$dest_dir/$f->{'url'}";
            print O $buffer;
            close(O);
            $f = $files[$grouped_file_idx] = $get_grouped_file->();
            $f->{'buffer'} .= join("", $get_header->($f));
            $f->{'buffer'} .= $table_headers;
        }
    }
}

&print_headers($page_footer);

foreach my $f (@files)
{
    open O, ">$dest_dir/$f->{'url'}";
    print O $f->{'buffer'};
    close(O);
}

open STYLE, ">$dest_dir/style.css";
print STYLE <<EOF;
body { background-color : white ; background-image : url(pics/backtux.gif) }
h1 { text-align : center }
td.c { text-align : center }
hr { height : 4px }
EOF
close (STYLE);

