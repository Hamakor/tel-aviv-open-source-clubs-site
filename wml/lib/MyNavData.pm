package MyNavData;

my $hosts =
{
    'telux' => 
    {
        'base_url' => "http://www.cs.tau.ac.il/telux/",
    },
};

my $tree_contents =
{
    'host' => "telux",
    'text' => "Tel Aviv Linux Club",
    'title' => "Tel Aviv Linux Club (Telux)",
    'subs' =>
    [
        {
            'text' => "Home",
            'url' => "",
        },
        {
            'text' => "Beginners' Series",
            'url' => "newbies.html",
            'subs' =>
            [
                {
                    'text' => "2003 Series",
                    'url' => "newbies-2003.html",
                },
                {
                    'text' => "InstaParty November 2003",
                    'url' => "instaparty-2003.html",
                    'title' => ("The Installation Party that took place at" . 
                        " November 2003"),
                    'subs' =>
                    [
                        {
                            'text' => "Pictures from the InstaParty",
                            'url' => "instaparty-2003-pictures.html",
                        },
                    ],
                },
            ],
        },
        {
            'text' => "Advanced Lectures",
            'url' => "advanced.html",
            'subs' => 
            [
                {
                    'text' => "2004 Lectures Archive",
                    'url' => "advanced-2004.html",
                },
            ],
        },
    ],
};

sub get_params
{
    return 
        (
            'hosts' => $hosts,
            'tree_contents' => $tree_contents,
        );
}

1;
