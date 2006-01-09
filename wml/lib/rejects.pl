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

