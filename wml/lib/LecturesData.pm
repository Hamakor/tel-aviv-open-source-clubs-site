package LecturesData;

require Exporter;

use vars qw(@ISA);

@ISA=qw(Exporter);

my @exported_vars = qw(%lecturer_aliases %lecturers %lectures %series_map %topics_map %topic_aliases %subject_render_callbacks @topics_order);

use vars @exported_vars;

use vars qw(@EXPORT);

@EXPORT=(@exported_vars);

%lecturer_aliases = 
(
    'dryice' => "meir_maor",
    'choo' => "guykeren",
    'kilmo' => "orrd",
    'muli' => "mulix",    
);

sub series_idx_subject_render
{
    my $lecture = shift;
    my $idx_in_series = shift;
    my $url = exists($lecture->{'url'}) ? $lecture->{'url'} : "$idx_in_series/";
    return "<a href=\"./lectures/$url\">" . $lecture->{'s'} . "</a>";
}

sub no_url_subject_render
{
    my $lecture = shift;

    return $lecture->{'s'};
}

sub explicit_url_subject_render
{
    my $lecture = shift;
    if (!exists($lecture->{'url'}))
    {
        die "URL not specified for Lecture " . $lecture->{'s'} . "!\n";
    }
    return "<a href=\"" . $lecture->{'url'} . "\">" . $lecture->{'s'} . "</a>";
}

%subject_render_callbacks =
(
    'explicit_url' => \&explicit_url_subject_render,
    'no_url' => \&no_url_subject_render,
    'series_idx' => \&series_idx_subject_render,
    'shlomif' => sub {
            my $lecture = shift;
            if (!exists($lecture->{'url'}))
            {
                die "URL not specified for Lecture " . $lecture->{'s'} . "!\n";
            }
            return "<a href=\"http://vipe.technion.ac.il/~shlomif/lecture/" . $lecture->{'url'} . "\">" . $lecture->{'s'} . "</a>";
        },
);

%lecturers = 
(
    'alex_landsberg' =>
    {
        'name' => "Alex Landsberg",
        'name_render_type' => "email",
        'email' => "alex.landsberg\@ligad.com",
        'subject_render' => "no_url",
    },
    'aviram' =>
    {
        'name' => "Aviram Jenik",
        'name_render_type' => "email",
        'email' => "aviram\@beyondsecurity.com",
        'subject_render' => "explicit_url",
    },
    'alon' =>
    {
        'name' => "Alon Altman",
        'name_render_type' => "email",
        'email' => "alon\@vipe.technion.ac.il",
        'subject_render' => "series_idx",
    },
    'asaf_arbely' =>
    {
        'name' => "Asaf Arbely",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'choo_and_eli' =>
    {
        'name' => "Guy Keren, Eli Billauer",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
    },
    'dan_kenigsberg' =>
    {
        'name' => "Dan Kenigsberg",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'dan_liberzon' => 
    {
        'name' => "Dan Liberzon",
        'name_render_type' => "email",
        'email' => "liberzon.at.eng.tau.ac.il",
        'subject_render' => "explicit_url",
    },
    'dani_arbel' =>
    {
        'name' => "Dani Arbel",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
    },
    'doron_bleiberg' =>
    {
        'name' => "Doron Bleiberg",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'eddie' => 
    {
        'name' => "Eddie Aronovich",
        'name_render_type' => "email",
        'subject_render' => "explicit_url",
        'email' => "eddiea\@cs.tau.ac.il",
    },
    'eli' =>
    {
        'name' => "Eli Billauer",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'eran_sandler' =>
    {
        'name' => "Eran Sandler",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'ez-aton' =>
    {
        'name' => "Ez-Aton",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'gby' =>
    {
        'name' => "Gilad Ben Yossef",
        'name_render_type' => "homepage",
        'homepage' => "http://www.benyossef.com/",
        'subject_render' => "explicit_url",
    },
    'guykeren' =>
    {
        'name' => "Guy Keren",
        'name_render_type' => "email",
        'email' => "choo\@actcom.co.il",
        'subject_render' => "series_idx",
    },
    'haifux_members' =>
    {
        'name' => "Haifux Members",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
    },
    'herouth_maoz' =>
    {
        'name' => "Herouth Maoz",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'iftach_hyams' =>
    {
        'name' => "Iftach Hyams",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
    },
    'lior_kaplan' =>
    {
        'name' => "Lior Kaplan",
        'name_render_type' => "email",
        'email' => "webmaster\@guides.co.il",
        'subject_render' => "explicit_url",
    },
    'mark_silberstein' =>
    {
        'name' => "Mark Silberstein",
        'name_render_type' => "email",
        'email' => "msilbers\@yahoo.com",
        'subject_render' => "no_url",       
    },
    'meir_maor' =>
    {
        'name' => "Meir Maor",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'mike_almogy' =>
    {
        'name' => "Mike Almogy",
        'name_render_type' => "email",
        'email' => "mike.at.lizard.co.il",
        'subject_render' => "explicit_url",
    },
    'moshe_doron' =>
    {
        'name' => "Moshe Doron",
        'name_render_type' => "email",
        'email' => "mosdoron\@netvision.net.il",
        'subject_render' => "explicit_url",
    },
    'moshez' =>
    {
        'name' => "Moshe Zadka",
        'name_render_type' => "homepage",
        'homepage' => "http://moshez.org/",
        'subject_render' => "explicit_url",
    },
    'mulix' =>
    {
        'name' => "Muli Ben Yehuda",
        'name_render_type' => "homepage",
        'email' => "mulix\@actcom.co.il",
        'homepage' => "http://www.mulix.org/",
        'subject_render' => "series_idx",
    },
    'mulix_and_choo' =>
    {
        'name' => "<a href=\"mailto:mulix\@actom.co.il\">Muli Ben-Yehuda</a> and " . 
            "<a href=\"mailto:choo\@actcom.co.il\">Guy Keren</a>",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'nadav_rotem' =>
    {
        'name' => "Nadav Rotem",
        'name_render_type' => "email",
        'email' => "nadav256\@hotmail.com",
        'subject_render' => "no_url",
    },
    'nir_simionovich' =>
    {
        'name' => "Nir Simionovich",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'oded_koren' =>
    {
        'name' => "Oded Koren",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
    },
    'ohad_bencohen' =>
    {
        name => "Ohad Ben-Cohen",
        'name_render_type' => "email",
        'email' => "absint\@netvision.net.il",
        'subject_render' => "explicit_url",
    },
    'oleg' =>
    {
        'name' => "Oleg Goldshmidt",
        'name_render_type' => "email",
        'email' => "pub\@goldshmidt.org",
        'subject_render' => "series_idx",
    },
    'omer_zak_and_ori_idan' =>
    {
        'name' => "Omer Zak and Ori Idan",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'ori_idan' =>
    {
        'name' => "Ori Idan",
        'name_render_type' => "email",
        'email' => "ori.at.helicontech.co.il",
        'subject_render' => "explicit_url",
    },
    'ori_idan_and_sforbes' =>
    {
        'name' => "Ori Idan &amp; Shoshannah Forbes",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'orna' =>
    {
        'name' => "Orna Agmon",
        'name_render_type' => "homepage",
        'subject_render' => "explicit_url",
        'homepage' => "http://tx.technion.ac.il/~agmon/",
    },
    'orna_and_mulix' =>
    {
        'name' => "Orna Agmon and Muli Ben-Yehuda",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'oron_peled' =>
    {
        'name' => "Oron Peled",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'orrd' =>
    {
        'name' => "Orr Dunkelman",
        'name_render_type' => "email",
        'email' => "orrd\@vipe.technion.ac.il",
        'subject_render' => "series_idx",
    },
    'ron_art' =>
    {
        'name' => "Ron Artstein",
        'name_render_type' => "homepage",
        'homepage' => "http://www.cs.technion.ac.il/~artstein/",
        'subject_render' => "series_idx",
    },
    'sagiv_barhoom' =>
    {
        'name' => "Sagiv Barhoom",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'sforbes' =>
    {
        'name' => "Shoshannah Forbes",
        'name_render_type' => "email",
        'homepage' => "http://www.xslf.com/",
        'email' => "xslf\@netvision.net.il",
        'subject_render' => "explicit_url",
    },
    'shimon_panfil' =>
    {
        'name' => "Shimon Panfil, Ph.D.",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'shlomif' =>
    {
        'name' => "Shlomi Fish",
        'name_render_type' => "homepage",
        'homepage' => "http://www.shlomifish.org/",
        'subject_render' => "explicit_url",
    },
    'shlomi_loubaton' =>
    {
        'name' => "Shlomi Loubaton",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'sun' =>
    {
        'name' => "Shachar Shemesh",
        'name_render_type' => "homepage",
        'homepage' => "http://www.lingnu.com/",
        'subject_render' => "explicit_url",
    },
    'telux_members' =>
    {
        'name' => "Telux Members",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'tzafrir' =>
    {
        'name' => "Tzafrir Cohen",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'tzahi_fadida' =>
    {
        'name' => "Tzahi Fadida",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'you' =>
    {
        'name' => "You, yes you",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
    },
    'yuval_shavitt' =>
    {
        'name' => "Yuval Shavitt",
        'name_render_type' => "homepage",
        'homepage' => "http://www.eng.tau.ac.il/~shavitt/",
        'subject_render' => "explicit_url",
    },
);

%series_map =
(
    'default' => 
    {
        'lecture_num_template' => 
            sub {
                my $lecture_num = shift;
                my %flags = (@_);
                if ($flags{'strict'})
                {
                    return 
                        {
                            'td-params' => " class=\"c\"",
                            'text' => $lecture_num,
                        };
                }
                else
                {
                    return "<div align=\"center\">$lecture_num</div>\n"
                }
            },
        'sub-series' =>
        {
            'SiL' => {
                'lecture_num_template' => sub {
                my $lecture_num = shift;
                my %flags = (@_);
                if ($flags{'strict'})
                {
                    return 
                        {
                            'td-params' => " class=\"c\"",
                            'text' => "$lecture_num SiL",
                        };
                }
                else
                {
                    return "<div align=\"center\">$lecture_num SiL</div>\n"
                }
            },
            },
        },
    },
    'w2l-2005' =>
    {
        'lecture_num_template' => 
            sub {
                my $lecture_num = shift;
                my %flags = (@_);
                if ($flags{'strict'})
                {
                    return 
                        {
                            'td-params' => " class=\"c\"",
                            'text' => "<a href=\"http://welcome.linux.org.il/\">Welcome to Linux</a> - $lecture_num",
                        };
                }
                else
                {
                    return "<div align=\"center\"><a href=\"http://welcome.linux.org.il/\">Welcome to Linux</a> - $lecture_num</div>\n"
                }
            },
    },
    'perl' =>
    {
        'lecture_num_template' =>
            sub {
                my $lecture_num = shift;
                return "<a href=\"http://vipe.technion.ac.il/~shlomif/lecture/Perl/Newbies/\">Programming in Perl - $lecture_num</a>";
            },        
    },
    'none' =>
    {
        'lecture_num_template' => sub {
                my $lecture_num = shift;
                return "";
        },
    },
);

%topics_map = 
(
    'advocacy' =>
    {
        'name' => "Advocacy and evangelism lectures",
        'url' => "advocacy",
        'title' => "Advocacy Related Lectures",
    },
    'kernel' =>
    {
        'name' => "Linux kernel lectures",
        'url' => "kernel",
        'title' => "Kernel Lectures",
    },
    'network' => 
    {
        'name' => "Networking lectures",
        'url' => "network",
        'title' => "Networking Lectures",
    },
    'prog' =>
    {
        'name' => "Programming related lectures",
        'url' => "programming",
        'title' => "Programming Related Lectures",
    },    
    'security' =>
    {
        'name' => "Security lectures",
        'url' => "security",
        'title' => "Security Lectures",
    },
    'system' =>
    {
        'name' => "Linux system lectures",
        'url' => "system",
        'title' => "System Lectures", 
    },
    'utils' =>
    {
        'name' => "Tools and utilities lectures",
        'url' => "util",
        'title' => "Tools and Utilities Lectures",
    },
);

@topics_order=(qw(kernel system network security prog utils advocacy));

%topic_aliases =
(
    (map { $_ => 'utils' } (qw(util tools tool))),
    'networking' => "network",
    'net' => "network",
    'advo' => "advocacy",
);

%lectures =
(
    '2003' =>
    [
        {
            l => "shlomif",
            s => "GIMP (Part 1/2)",
            d => "21/9",
            t => "utils",
            url => "http://vipe.technion.ac.il/~shlomif/lecture/Gimp/",
        },
        {
            l => "shlomif",
            s => "GIMP (Part 2/2)",
            d => "19/10",
            t => "utils",
            'url' => "http://vipe.technion.ac.il/~shlomif/lecture/Gimp/",
        },
        {
            l => "eddie",
            s => "From RPC to Web Services",
            d => "2/11",
            t => "utils",
            'url' => "http://www.cs.tau.ac.il/~eddiea/docs/From_rpc_to_web_services.pdf",
        },
        {
            l => "lior_kaplan",
            s => "Intro to PHP (Part 1/2)",
            d => "16/11",
            'url' => "http://www.haifux.org/lectures/43/",
            t => "prog",
        },
        {
            'l' => "sun",
            's' => "Wine",
            'd' => "30/11",
            't' => [qw(prog system)],
            'url' => "lin-club_files/TeluxWine05.sxi",
        },
        {
            l => "lior_kaplan",
            s => "Intro to PHP (Part 2/2)",
            d => "14/12",
            'url' => "http://www.haifux.org/lectures/43/",
            t => "prog",
        },
        {
            l => "aviram",
            s => "Full Disclosure",
            d => "28/12",
            url => "lin-club_files/Full_Disclosure.sxi",
            t => [qw(prog system)],
        },
    ],
    '2004' =>
    [
        {
            l => "gby",
            s => "Embedded Linux",
            d => "11/1",
            url => "lin-club_files/embedded_telux.sxi",
            t => "prog",
        },
        {
            l => "alex_landsberg",
            s => "OSCAR - a Tool for Grid Implementation",
            d => "25/1",
            'comments' => q{<a href="http://oscar.openclustergroup.org/tiki-list_file_gallery.php?galleryId=4">oscar-mit (Jeremy Enos@MIT)</a>},
            t => [qw(prog system net)],
        },
        {
            l => "moshe_doron",
            s => "Extending PHP",
            d => "8/2",
            url => "http://moshe.i-com-it.com/p/pres2/show.php?file=extending-php",
            t => "prog",
        },
        {
            l => "ori_idan_and_sforbes",
            s => "The Open Source Development Model and How you can Contribute",
            d => "22/2",
            url => "lin-club_files/non-prog-oss.sxi",
            t => ["prog","advocacy",],
        },
        {
            l => "ohad_bencohen",
            s => "Securing Linux",
            d => "14/3",
            url => "lin-club_files/securing_linux.sxi.zip",
            t => "system",
        },
        {
            l => "orna",
            s => "Portable Programming",
            d => "28/3",
            url => "http://haifux.org/lectures/72/",
            t => "prog",
        },
        {
            l => "eddie",
            s => "Intro to Apache 2",
            d => "18/4",
            url => "http://www.cs.tau.ac.il/~eddiea/docs/apache-into-telux-2004-04.ps",
            t => "system",
        },
        {
            l => "ori_idan",
            s => "Gtk+",
            d => "2/5",
            url => "lin-club_files/gtk.sxi",
            t => "prog",
        },
        {
            l => "mike_almogy",
            s => "Web Hosting (Part 1/2)",
            d => "16/5",
            url => "lin-club_files/linux-webhosting.pdf",
            comments => q{<a href="lin-club_files/linux-webhosting.sxi">Lecture
            in SXI Format</a>},
            t => [qw(system net)],
        },
        {
            l => "dan_liberzon",
            s => "The Mandrake Distribution",
            d => "30/5",
            url => "lin-club_files/mandrake-club.sxi",
            comments => q{<a href="lin-club_files/mandrake-club.pdf">Lecture in PDF Format</a>},
            t => [qw(system advocacy)],
        },
        {
            l => "shlomif",
            s => "Autoconf",
            d => "4/7",
            url => "http://vipe.technion.ac.il/~shlomif/lecture/Autotools/",
            t => "prog",
        },
        {
            l => "mike_almogy",
            s => "Web Hosting (Part 2/2)",
            d => "18/7",
            url => "lin-club_files/linux-webhosting.pdf",
            comments => q{<a href="lin-club_files/linux-webhosting.sxi">Lecture
            in SXI Format</a>},
            t => [qw(system net)],            
        },
        {
            l => "sforbes",
            s => "Bugzilla",
            d => "1/8",
            url => "lin-club_files/bugzilla_for_end_users.pdf",
            t => "prog",
        },
        {
            l => "ori_idan",
            s => "Linux Bootloaders",
            d => "15/8",
            url => "lin-club_files/linux-boot/",
            t => ["prog","system"],
        },
        {
            l => "gby",
            s => "Asterisk - the Open-Source PABX System",
            d => "29/8",
            t => [qw(system net)],
            'subject_render' => "no_url",
        },
        {
            l => "orna_and_mulix",
            s => "Latest Kernel Developments (Impressions from OLS 2004)",
            d => "5/9",
            url => "http://www.haifux.org/lectures/109/OLS2004.html",
            t => [qw(prog advocacy)],
        },
        {
            l => "shlomif",
            s => "Freecell Solver - Evolution of a C Program",
            d => "19/9",
            url => "http://vipe.technion.ac.il/~shlomif/lecture/Freecell-Solver/",
            t => "prog",
        },
        {
            l => "telux_members",
            s => "Lightning Talks by Various People",
            d => "10/10",
            url => "http://www.iglu.org.il/IGLU/modules.php?op=modload&name=News&file=article&sid=64&mode=thread&order=0&thold=0",
            t => [],
        },
        {
            l => "ori_idan",
            s => "Linux Bootloaders",
            d => "24/10",
            url => "lin-club_files/linux-boot/",
            'comments' => q{Rerun of previous lecture},
            t => ["prog","system"],
        },
    ],
    '2005' =>
    [
        {
            l => "sun",
            s => "Bourne Shell Programming",
            d => "23/1",
            t => ["system"],
            'url' => "lin-club_files/bash.sxi",
        },
        {
            l => "omer_zak_and_ori_idan",
            s => "Accessibility in Linux", 
            d => "6/2",
            url => "lecture-notes/Lecture112zak-A-2005jan09.pdf",
            t => ["system","util"],
            comments => q{<a href="lecture-notes/Lecture112zak-A-2005jan09.sxi">SXI Format</a><br /><a href="http://www.haifux.org/lectures/112/">Second Part of the Lecture</a>},
        },
        {
            l => "nir_simionovich",
            d => "27/2",
            s => "Advanced Topics in Asterisk",
            url => "lecture-notes/Asterisk_Open_Source_PBX-Telux_Presentation.pdf",
            t => ["system", "net"],
        },
        {
            l => "herouth_maoz",
            d => "20/3",
            s => "GIMP 2.2",
            url => "lecture-notes/gimp-herouth-slides/",
            t => "utils",
            'comments' => q{<a href="http://vipe.technion.ac.il/~shlomif/lecture/Gimp/">Original Lecture by Shlomi Fish</a> (in English and with different images)},
        },
        {
            l => "ori_idan",
            d => "17/4",
            s => "Embedded Linux Bring-Up - A Short War Story",
            url => "http://www.helicontech.co.il/whitepapers/LinuxBringUp.html",
            t => ["kernel", "system"],
        },
        {
            l => "eddie",
            d => "1/5",
            s => "Condor",
            url => "lecture-notes/condor-introduction-long-version.pdf",
            t => ["net", "system"],
        },
        {
            l => "sun",
            d => "15/5",
            s => "The Debian GNU/Linux QA System",
            url => "lecture-notes/Debian_QA.sxi",
            t => ["advocacy", "prog"],
        },
        {
            l => "yuval_shavitt",
            s => "DIMES - Mapping the Internet",
            d => "26/6",
            t => ["prog", "net"],
            url => "",
        },
        {
            l => "telux_members",
            d => "10/7",
            s => "Lightning Talks",
            url => "",
            t => [],
        },
        {
            l => "oron_peled",
            d => "24/7",
            s => "SELinux",
            t => ["security", "system"],
            url => "http://www.haifux.org/lectures/128",
        },
        {
            l => "ori_idan",
            d => "7/8",
            s => "Kernel Building",
            url => "",
            t => ["kernel", "system"],
        },
        {
            l => "eddie",
            d => "21/8",
            s => "Network Programming",
            url => "",
            t => ["prog", "net"],
        },
        {
            l => "eddie",
            d => "11/9",
            s => "Network Programming - Part 2",
            url => "",
            t => ["prog", "net"],
        },
        {
            l => "eddie",
            d => "13/11",
            s => "Blitz Lecture",
            url => "http://www.shlomifish.org/lecture/W2L/Blitz/slides/",
            t => [],
            'series' => "w2l-2005",
            'comments' => q{
                <p>
                Everything one needs to know to start with Linux - 
                applications, interfaces, working in the command shell,
                getting help, configuration tools, package installation
                and a little on the philosophy of open-source.
                </p>
            },
        },
        {
            l => "sagiv_barhoom",
            d => "20/11",
            s => "Linux for the Student",
            url => "lin-club_files/w2l-linux_for_student1.sxi",
            t => [],
            'series' => "w2l-2005",
            'comments' => q{Using OpenOffice.org and other useful tools
            for the school and the university},
        },
        {
            l => "meir_maor",
            d => "27/11",
            s => "Living in the Community",
            url => "lecture-notes/how-to-ask-questions-the-smart-way.sxi",
            t => [],
            'series' => "w2l-2005",
            'comments' => q{How to live and get help from the Linux community.
                Terms, resources, and etiquette.},
        },
        {
            l => "gby",
            d => "4/12",
            s => "Development Tools in Linux",
            url => "http://www.shlomifish.org/lecture/W2L/Development/",
            t => [],
            'series' => "w2l-2005",
            'comments' => q{Popular and useful software development tools
                for Linux},
        },
        {
            l => "ori_idan",
            d => "11/12",
            s => "The Linux Installation Process",
            url => "http://vipe.technion.ac.il/~adir/lectures/MandrakeInstLect.pdf",
            t => [],
            'series' => "w2l-2005",
            'comments' => q{How to install Linux, and what one should be
                aware of},
        },
    ],
    '2006' =>
    [
        {
            l => "sagiv_barhoom",
            d => "8/1",
            s => "The Vim Editor for Beginners",
            url => "http://www.shlomifish.org/lecture/Vim/beginners/",
            t => ["prog", "utils"],
        },
        {
            l => "doron_bleiberg",
            d => "22/1",
            s => "CASE (= Computer Aided Software Engineering) Tools and What's Between Them",
            url => "",
            t => ["prog"],
        },
    ],
);

=begin Nothing

This is NirS' presentation that was postponed due to his inavailability
and Eddie's other parts of the Net Programming presentations.

        {
            l => "nir_simionovich",
            d => "4/9",
            s => "GnuGK - The GNU GateKeeper Implementation",
            url => "",
            t => ["system", "net"],
        },

=end Nothing

=cut
