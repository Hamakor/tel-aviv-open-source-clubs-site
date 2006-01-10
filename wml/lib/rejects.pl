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


######### Removing the headers mechanism - it is bloat.
# A user can always add his own headers before and after the 
# generated HTML .

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

my $page_footer = "</table>\n<hr />\n" . 
    "<h3><a href=\"all.html\">All the Lectures</a></h3>\n" .
    "<h3>Other Lectures Sorted by Number</h3>\n" .
    "<ul>\n" . 
        join("", 
            (map 
                { 
                    my ($f, $l) = $date_pres_man->get_group_indexes($_); 
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

&print_headers($table_headers);

&print_headers($page_footer);

            #&print_headers(
                #    "</table>\n",
                # "<h2>Future Lectures</h2>\n",
                #$table_headers
                # );


        {
            my $f = $files[$grouped_file_idx];
            my $buffer = $f->{'buffer'};
            $buffer .= $page_footer;
            open O, ">", $date_pres_man->dest_dir() . "/$f->{'url'}";
            print O $buffer;
            close(O);
            $f = $files[$grouped_file_idx] = $date_pres_man->get_grouped_file();
            $f->{'buffer'} .= join("", $get_header->($f));
            $f->{'buffer'} .= $table_headers;
        }
                


#####################################################################
# Removing the get_grouped_file functionality because it's not used
# in Telux - to be restored later in a better way.
continue
{
    my $series = $lecture->{'series'};
    my $lecture_idx = ($date_pres_man->series_indexes()->{$series}++);
    if (($series eq 'default') && ($lecture_idx == $last_idx_in_group))
    {
        $date_pres_man->group_id($date_pres_man->group_id()+1);
        if (defined($grouped_file_idx))
        {
            my $f = $files[$grouped_file_idx];
            my $buffer = $f->{'buffer'};
            open O, ">", $date_pres_man->dest_dir() . "/$f->{'url'}";
            print O $buffer;
            close(O);
            $files[$grouped_file_idx] = $date_pres_man->get_grouped_file();
        }
    }
}

my $num_default_lectures = scalar(grep { $_->{'series'} eq 'default' } (@lectures_flat));

my $last_idx_in_group = 20;

sub get_group_indexes
{
    my $self = shift;
    my $group_id = shift;
    my $first_idx = $self->num_lectures_in_group()*($group_id-1)+1;
    my $last_idx = $first_idx+$self->num_lectures_in_group()-1;

    return ($first_idx, $last_idx);
}

sub get_grouped_file
{
    my $self = shift;

    my ($first_idx, $last_idx) = $self->get_group_indexes($self->group_id());
    $last_idx_in_group = $last_idx;
    return {
        'id' => "grouped",
        'url' => "lectures" . $self->group_id() . ".html",
        't_match' => ".*",
        '<title>' => "Haifa Linux Club (Lectures $first_idx-$last_idx)",
        'h1_title' => "Haifa Linux Club - Lectures $first_idx-$last_idx",
        'buffer' => "",
    };
}

my ($grouped_file_idx) = (grep { $files[$_]->{'id'} eq "grouped" } (0 .. $#files));


##############################
# Removing the topics_order - craft from Haifux.

my @topics_order=(qw(kernel system network security prog utils advocacy));

