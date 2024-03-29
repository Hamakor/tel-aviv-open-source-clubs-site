package LecturesData;

use strict;
use warnings;

my %lecturer_aliases =
(
    'conan' => "constantine_shulyupin",
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

my $empty_url = "special://empty/";

sub explicit_url_subject_render
{
    my $lecture = shift;
    if (!exists($lecture->{'url'}))
    {
        die "URL not specified for Lecture " . $lecture->{'s'} . "!\n";
    }
    if ($lecture->{'url'} eq $empty_url)
    {
        return $lecture->{'s'};
    }
    return "<a href=\"" . $lecture->{'url'} . "\">" . $lecture->{'s'} . "</a>";
}

my %subject_render_callbacks =
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
            return "<a href=\"http://www.shlomifish.org/lecture/" . $lecture->{'url'} . "\">" . $lecture->{'s'} . "</a>";
        },
);

my %lecturers =
(
    'alex_landsberg' =>
    {
        'name' => "Alex Landsberg",
        'name_render_type' => "email",
        'email' => "alex.landsberg\@ligad.com",
        'subject_render' => "no_url",
    },
    'alex_nerst_and_michal_geva' =>
    {
        'name' => "Alex Nerst and Michal Geva",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'alexander_sirotkin' =>
    {
        'name' => "Alexander Sirotkin",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
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
    'constantine_shulyupin' =>
    {
        'name' => "Constantine Shulyupin",
        'name_render_type' => "homepage",
        'homepage' => "http://www.linuxdriver.co.il/",
        'subject_render' => "explicit_url",
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
    'david_khosid' =>
    {
        'name' => "David Khosid",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'doron_bleiberg' =>
    {
        'name' => "Doron Bleiberg",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'drupal_il' =>
    {
        'name' => "Drupal Israel",
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
    'elizabeth_sterling' =>
    {
        'name' => "Elizabeth Sterling",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'eran_sandler' =>
    {
        'name' => "Eran Sandler",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'erez_d' =>
    {
        'name' => "Erez Doron",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
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
    'ido_kanner' =>
    {
        'name' => "Ido Kanner",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'iftach_hyams' =>
    {
        'name' => "Iftach Hyams",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
    },
    'jacob_dunk' =>
    {
        'name' => "Jacob Dunkelman",
        'name_render_type' => "email",
        'email' => "jacbod\@tbm.co.il",
        'subject_render' => "explicit_url",
    },
    'ohad_levy' =>
    {
        'name' => "Ohad Levy",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'jon_klinger' =>
    {
        'name' => "Jonathan Klinger",
        'name_render_type' => "homepage",
        'homepage' => "http://www.2jk.org/praxis/",
        'subject_render' => "explicit_url",
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
    'meital_bourvine' =>
    {
        'name' => "Meital Bourvine",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'micha_silver' =>
    {
        'name' => "Micha Silver",
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
    'nadav_vinik' =>
    {
        'name' => "Nadav Vinik",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
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
    'ram_rachum' =>
    {
        'name' => "Ram Rachum (cool-RR)",
        'name_render_type' => "homepage",
        'homepage' => "http://garlicsim.org/",
        'subject_render' => "explicit_url",
    },
    'rami_addady' =>
    {
        'name' => "Rami Addady",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
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
    'sawyer' =>
    {
        'name' => "Yaron Meiry (Sawyer)",
        'name_render_type' => "homepage",
        'homepage' => "http://blogs.perl.org/users/sawyer_x/",
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
    'szabgab' =>
    {
        'name' => "Gabor Szabo",
        'name_render_type' => "homepage",
        'homepage' => "http://szabgab.com/",
        'subject_render' => "explicit_url",
    },
    'tal_ko' =>
    {
        'name' => "Tal Ko",
        'name_render_type' => "plain",
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
    'vitaly_karasik' =>
    {
        'name' => "Vitaly Karasik",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'you' =>
    {
        'name' => "You, yes you",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
    },
    'yuval_tal' =>
    {
        'name' => "Yuval Tal",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'yuval_shavitt' =>
    {
        'name' => "Yuval Shavitt",
        'name_render_type' => "homepage",
        'homepage' => "http://www.eng.tau.ac.il/~shavitt/",
        'subject_render' => "explicit_url",
    },
    'zohar_babin' =>
    {
        'name' => "Zohar Babin",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
    },
    'zohar_snir' =>
    {
        'name' => "Zohar Snir",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
    'zvi_devir' =>
    {
        'name' => "Zvi Devir",
        'name_render_type' => "plain",
        'subject_render' => "explicit_url",
    },
);

sub w2l_lecture_num_template
{
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
}


sub w2foss_lecture_num_template
{
    my $lecture_num = shift;
    my %flags = (@_);
    if ($flags{'strict'})
    {
        return
            {
                'td-params' => " class=\"c\"",
                'text' => "<a href=\"http://welcome.foss.org.il/\">Welcome to FOSS</a> - $lecture_num",
            };
    }
    else
    {
        return "<div align=\"center\"><a href=\"http://welcome.foss.org.il/\">Welcome to FOSS</a> - $lecture_num</div>\n";
    }
}

my %series_map =
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
        'lecture_num_template' => \&w2l_lecture_num_template,
    },
    'w2l-2006' =>
    {
        'lecture_num_template' => \&w2l_lecture_num_template,
    },
    'w2l-2007' =>
    {
        'lecture_num_template' => \&w2l_lecture_num_template,
    },
    'w2l-2008' =>
    {
        'lecture_num_template' => \&w2l_lecture_num_template,
    },
    'w2foss-2009' =>
    {
        'lecture_num_template' => \&w2foss_lecture_num_template,
    },
    'perl' =>
    {
        'lecture_num_template' =>
            sub {
                my $lecture_num = shift;
                return "<a href=\"http://www.shlomifish.org/lecture/Perl/Newbies/\">Programming in Perl - $lecture_num</a>";
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

my %topics_map =
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

my %topic_aliases =
(
    (map { $_ => 'utils' } (qw(util tools tool))),
    'networking' => "network",
    'net' => "network",
    'advo' => "advocacy",
);

my %lectures =
(
    '2003' =>
    [
        {
            l => "shlomif",
            s => "GIMP (Part 1/2)",
            d => "21/9",
            t => "utils",
            url => "http://www.shlomifish.org/lecture/Gimp/",
        },
        {
            l => "shlomif",
            s => "GIMP (Part 2/2)",
            d => "19/10",
            t => "utils",
            'url' => "http://www.shlomifish.org/lecture/Gimp/",
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
            url => "http://www.shlomifish.org/lecture/Autotools/",
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
            url => "http://www.shlomifish.org/lecture/Freecell-Solver/",
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
            'comments' => q{<a href="http://www.shlomifish.org/lecture/Gimp/">Original Lecture by Shlomi Fish</a> (in English and with different images)},
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
            url => $empty_url,
        },
        {
            l => "telux_members",
            d => "10/7",
            s => "Lightning Talks",
            url => $empty_url,
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
            url => $empty_url,
            t => ["kernel", "system"],
        },
        {
            l => "eddie",
            d => "21/8",
            s => "Network Programming",
            url => $empty_url,
            t => ["prog", "net"],
        },
        {
            l => "eddie",
            d => "11/9",
            s => "Network Programming - Part 2",
            url => $empty_url,
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
                </p>},
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
            d => "29/1",
            s => "CASE (= Computer Aided Software Engineering) Tools and What's Between Them",
            url => $empty_url,
            t => ["prog"],
        },
        {
            l => "eddie",
            d => "12/2",
            s => "Grid Computing - the Real Power of a Community",
            url => $empty_url,
            t => ["net", "prog"],
        },
        {
            l => "herouth_maoz",
            d => "12/3",
            s => "GIMP 2.2",
            url => "lecture-notes/gimp-herouth-slides/",
            t => "utils",
            'comments' => q{Rerun. <a href="http://www.shlomifish.org/lecture/Gimp/">Original Lecture by Shlomi Fish</a> (in English and with different images)},
        },
        {
            l => "vitaly_karasik",
            d => "26/3",
            s => "Linux Kernel Tuning and Customization",
            url => "lecture-notes/karasik-kernel/",
            t => ["kernel"],
        },
        {
            l => "ori_idan",
            d => "9/4",
            s => "Embedded Linux Bring-Up - A Short War Story",
            url => "http://www.helicontech.co.il/whitepapers/LinuxBringUp.html",
            t => ["kernel", "system"],
            'comments' => q{Rerun.},
        },
        {
            l => "shlomif",
            d => "23/4",
            s => "Perl for Newbies - Part 1",
            url => "http://www.shlomifish.org/lecture/Perl/Newbies/",
            t => ["util", "prog"],
        },
        {
            l => "nir_simionovich",
            d => "14/5",
            s => "Voice-over-IP and Asterisk for Newbies or Welcome to Asterisk...",
            url => "lecture-notes/NirS-VoIP-from-the-eye-of-a-SysAdmin.ppt",
            t => ["system", "net"],
        },
        {
            l => "shlomif",
            d => "21/5",
            s => "Perl for Newbies - Part 2",
            url => "http://www.shlomifish.org/lecture/Perl/Newbies/",
            t => ["util", "prog"],
        },
        {
            l => "eddie",
            d => "5/11",
            s => "Blitz Lecture",
            url => "http://www.shlomifish.org/lecture/W2L/Blitz/slides/",
            t => [],
            'series' => "w2l-2006",
            'comments' => <<"EOF",
<p>
Everything one needs to know to start with Linux -
applications, interfaces, working in the command shell,
getting help, configuration tools, package installation
and a little on the philosophy of open-source.
</p>
<p>
<a href="http://dafdefan.blogspot.com/2006/11/blog-post_13.html">A video of the presentation courtesy of Lior Solomon is available</a>.
</p>
EOF
        },
        {
            l => "sagiv_barhoom",
            d => "12/11",
            s => "Linux for the Student",
            url => "lin-club_files/w2l-linux_for_student1.sxi",
            t => [],
            'series' => "w2l-2006",
            'comments' => q{Using OpenOffice.org and other useful tools
            for the school and the university},
        },
        {
            l => "ori_idan",
            d => "19/11",
            s => "Living in the Community",
            url => "lecture-notes/how-to-ask-questions-the-smart-way.sxi",
            t => [],
            'series' => "w2l-2006",
            'comments' => q{How to live and get help from the Linux community.
                Terms, resources, and etiquette.},
        },
        {
            l => "gby",
            d => "26/11",
            s => "Development Tools in Linux",
            url => "http://www.shlomifish.org/lecture/W2L/Development/",
            t => [],
            'series' => "w2l-2006",
            'comments' => q{Popular and useful software development tools
                for Linux},
        },
        {
            l => "zohar_snir",
            d => "3/12",
            s => "The Linux Installation Process",
            url => "lecture-notes/Linux-Installation-Process-2006.odp",
            t => [],
            'series' => "w2l-2006",
            'comments' => q{How to install Linux, and what one should be
                aware of.
                <a href="lecture-notes/Linux-Installation-Process-2006.pdf">Lecture
                Notes in PDF Format</a>},
        },
    ],
    '2007' =>
    [
        {
            l => "ido_kanner",
            d => "7/1",
            s => "The Free Pascal Compiler - Beyond the myths, when clearing the fog",
            url => "http://ik.homelinux.org/index.rhtml/other/lectures/fpc_about",
            t => ["prog"],
        },
        {
            l => "ori_idan",
            d => "21/1",
            s => "Running Linux on an ARM 7 Board",
            url => "lin-club_files/Ori-Idan-Linux-ARM7TDMI.odp",
            t => ["kernel", "system"],
        },
        {
            l => "jacob_dunk",
            d => "4/2",
            s => "CAD/CAM in Linux",
            url => $empty_url,
            t => ["tools"],
        },
        {
            l => "elizabeth_sterling",
            d => "25/2",
            s => "Setting up and Managing an Apache Server",
            url => "lin-club_files/Elizabeth-Sterling-ApachePresentation.odp",
            t => ["system", "net"],
        },
        {
            l => "elizabeth_sterling",
            d => "11/3",
            s => "Emacs",
            url => $empty_url,
            t => ["tools", "system"],
        },
        {
            l => "sun",
            d => "1/4",
            s => "Why the Smallest RSA Private Key is not 42 (it's 47)",
            url => "lin-club_files/Shachar-Shemesh--RSA-lecture.odp",
            t => ["system", "security", "prog"],
        },
        {
            l => "nadav_vinik",
            d => "22/7",
            s => "Firebug",
            url => $empty_url,
            t => ["net", "prog"],
        },
        {
            l => "nadav_vinik",
            d => "5/8",
            s => "JavaScript, AJAX and DOM",
            url => $empty_url,
            t => ["net", "prog"],
        },
        {
            l => "telux_members",
            d => "19/8",
            s => "Short Presentations by Various People",
            url => $empty_url,
            t => [],
            comments => <<"EOF",
<ul>
<li>
<a href="http://www.shlomifish.org/lecture/joel-test/">Shlomi Fish's slides
about the Joel Test</a>
</li>
<li>
<a href="lecture-notes/Meital-Bourvine-Reconstructor-Slides.odp">Meital
Bourvine's slides about Reconstructor</a>
</li>
</ul>
EOF
        },
        {
            l => "alexander_sirotkin",
            d => "16/9",
            s => "Embedded Linux",
            url => $empty_url,
            t => ["prog","system"],
            comments => <<"EOF",
<ul>
<li>
<a href="http://www.linuxconf.eu/2007/programme/abstract-ASirotkin-1.shtml">Link
to the Paper</a> as presented on LinuxConf Europe 2007.
</li>
</ul>
EOF
        },
        {
            l => "shlomif",
            d => "21/10",
            s => "Collective Hacking Session - Archive::Zip",
            url => $empty_url,
            t => ["prog"],
            comments => <<"EOF",
<p>
We gather and work together on an open source project. This time, we're working
on the <a href="http://search.cpan.org/dist/Archive-Zip/">Archive-Zip</a>
module.
</p>
EOF
        },
        {
            l => "meital_bourvine",
            d => "4/11",
            s => "Welcome-to-Linux \"Intro to Linux\" Rehearsal",
            url => "http://www.shlomifish.org/lecture/W2L/Blitz/",
            t => ["advocacy","utils",],
        },
        {
            l => "meital_bourvine",
            d => "2/12",
            s => "Intro to Linux",
            url => "http://www.shlomifish.org/lecture/W2L/Mini-Intro/slides/",
            t => [],
            'series' => "w2l-2007",
            'comments' => <<"EOF",
<p>
A brief intro to Linux in order for beginners to be familiar with it,
and to allow them to understand it and start working with it.
</p>
<p>
<a href="lecture-notes/W2L-Mini-Intro-Presentation-by-Meital-Bourvine.odp">Slides
in OpenDocument format</a>. (for OpenOffice.org, etc.)
</p>
EOF
        },
        {
            l => "sagiv_barhoom",
            d => "9/12",
            s => "Linux for the Student",
            url => "lecture-notes/w2l-2007-linux-for-student.zip",
            t => [],
            'series' => "w2l-2007",
            'comments' => q{Using OpenOffice.org and other useful tools
            for the school and the university},
        },
        {
            l => "ori_idan",
            d => "16/12",
            s => "Living in the Community",
            url => "lecture-notes/w2l-2007-how-to-ask-qs.odp",
            t => [],
            'series' => "w2l-2007",
            'comments' => q{How to live in, and get help from the Linux
                community. Terms, resources, and etiquette.},
        },
        {
            l => "elizabeth_sterling",
            d => "23/12",
            s => "Development Tools in Linux",
            url => "lecture-notes/w2l-2007-Linux-Devel-Tools.odp",
            t => [],
            'series' => "w2l-2007",
            'comments' => q{Popular and useful software development tools
                for Linux},
        },
        {
            l => "zohar_snir",
            d => "30/12",
            s => "The Linux Installation Process",
            url => "lecture-notes/w2l-2007-Linux-Installation-Process.odp",
            t => [],
            'series' => "w2l-2007",
            'comments' => q{How to install Linux, and what one should be
                aware of.
                <a href="lecture-notes/Linux-Installation-Process-2006.pdf">Lecture
                Notes in PDF Format</a>},
        },
    ],
    '2008' =>
    [
        {
            l => "micha_silver",
            d => "20/01",
            s => "Open Source GIS (Geographic Information Systems) - State of the Art",
            url => $empty_url,
            t => ["prog", "util"],
            comments => <<"EOF"
<p>
<a href="abstracts/foss-gis.html">Abstract</a>
</p>
EOF
        },
        {
            l => "elizabeth_sterling",
            d => "27/01",
            s => "Using the Command Line",
            url =>  "lecture-notes/Elizabeth-Sterling--The-Linux-Command-Line-Interface.odp",
            t => ["prog", "system", "util"],
            comments => <<"EOF"
Using the UNIX/Linux command line for fun and profit.
EOF
        },
        {
            l => "sagiv_barhoom",
            d => "3/02",
            s => "Introduction to Linux Scripting",
            url => "lecture-notes/Sagiv-Barhoom--bash_vs_perl.tar.gz",
            t => ["prog", "system", "util"],
        },
        {
            l => "yuval_tal",
            d => "17/02",
            s => "XBMC - The Xbox Media Center",
            url => $empty_url,
            t => ["prog", "util"],
            comments => <<"EOF"
<p>
<a href="http://www.xboxmediacenter.com/">Xbox Media Center (XBMC) Homepage</a>
</p>
EOF
        },
        {
            l => "telux_members",
            d => "15/06",
            s => "Vim Tips and Tricks",
            url => "http://www.shlomifish.org/lecture/Vim/telux-tips-and-tricks/",
            t => ["prog", "util"],
            comments => <<"EOF"
<p>
We will meet to share Tips and Tricks of <a href="http://www.vim.org/">the
Vim editor</a>. Bring in your favourite tips and tricks, .vimrc customisations,
etc.
</p>

<p>
This is a joint meeting - Tel Aviv OSDClub (Open Source Developers' Club).
</p>
EOF
        },
        {
            l => "telux_members",
            d => "29/06",
            s => "Software Management Discussion/Brainstorming",
            url => "http://wiki.perl.org.il/index.php/Meeting_on_29_June_2008",
            t => ["prog"],
        },
        {
            l => "ori_idan",
            d => "13/07",
            s => "Internet Standards - Why, Who and How",
            url => "http://www.w3c.org.il/files/phpgroup.pdf",
            t => ["prog", "advocacy", "util",],
            comments => <<"EOF",
<ul>
<li>
<a href="http://wiki.perl.org.il/index.php/Meeting_on_13_July_2008">Wiki
Page about the Meeting</a>
</li>
</ul>
EOF
        },
        {
            l => "ido_kanner",
            d => "27/07",
            s => "puts ruby - Introduction to the Cool Stuff and Pitfalls of Ruby",
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_27_July_2008",
            t => ["prog","util",],
            comments => <<"EOF",
<ul>
<li><a href="http://ik.homelinux.org/index.rhtml/other/lectures/puts_ruby">slides on Ido's site</a></li>
<li><b>Local</b>: <a href="lecture-notes/puts_ruby.odp">OpenDocument
Format</a>, <a href="lecture-notes/puts_ruby.pdf">PDF Format</a>.
</li>
</ul>
EOF
        },
        {
            l => "jon_klinger",
            d => "03/08",
            s => "Open Source Licences - History and Overview",
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_03_August_2008",
            t => ["advocacy", "prog",],
        },
        {
            l => "ohad_levy",
            d => "07/09",
            s => "Puppet - the Cross-Platform Central Management Tool",
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_07_September_2008",
            t => ["util", "system", "security"],
            comments => <<"EOF",
<ul>
<li><a href="lecture-notes/puppet-teluxmeet.pdf">Slides in
PDF Format</a></li>
</ul>
EOF
        },
        {
            l => "ori_idan",
            d => "21/09",
            s => "The Semantic Web",
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_21_September_2008",
            t => ["advocacy", "prog"],
            comments => <<"EOF",
<ul>
<li><a href="lecture-notes/semanticweb.pdf">Slides in PDF Format</a></li>
<li><a href="lecture-notes/semanticweb.odp">Slides in ODP (OpenDocument / OpenOffice.org) Format</a></li>
</ul>
EOF
        },
        {
            l => "eddie",
            d => "23/11",
            s => "Intro to Linux",
            url => "http://www.shlomifish.org/lecture/W2L/Mini-Intro/slides/",
            t => [],
            'series' => "w2l-2008",
            'comments' => <<"EOF",
<p>
A brief intro to Linux in order for beginners to become familiar with it,
and to allow them to understand it and start working with it.
</p>
EOF
        },
        {
            l => "zohar_snir",
            d => "30/11",
            s => "The Linux Installation Process",
            url => "lecture-notes/w2l-2008-Linux-Installation-Process.odp",
            t => [],
            'series' => "w2l-2008",
            'comments' => q{How to install Linux, and what one should be
                aware of.
                <a href="lecture-notes/Linux-Installation-Process-2006.pdf">Lecture
                Notes in PDF Format</a>},
        },
        {
            l => "sagiv_barhoom",
            d => "7/12",
            s => "Linux for the Student",
            url => "lecture-notes/w2l-2007-linux-for-student.zip",
            t => [],
            'series' => "w2l-2008",
            'comments' => q{Using OpenOffice.org and other useful tools
            for the school and the university},
        },
        {
            l => "ori_idan",
            d => "14/12",
            s => "Living in the Community",
            url => "lecture-notes/w2l-2007-how-to-ask-qs.odp",
            t => [],
            'series' => "w2l-2008",
            'comments' => q{How to live in, and get help from the Linux
                community. Terms, resources, and etiquette.},
        },
        {
            l => "telux_members",
            d => "21/12",
            s => "Hamakor General Assembly",
            url => "http://www.hamakor.org.il/content/view/98/1/",
            t => [],
        },
        {
            l => "elizabeth_sterling",
            d => "28/12",
            s => "Development Tools in Linux",
            url => "http://www.shlomifish.org/lecture/W2L/Development/",
            t => [],
            'series' => "w2l-2008",
            'comments' => q{Popular and useful software development tools
                for Linux. <b>Note:</b> Date Change.},
        },
    ],
    '2009' =>
    [
        {
            l => "szabgab",
            d => "04/01",
            s => "GUI Development with wxPerl and Padre, the Perl IDE",
            t => ["advocacy", "prog", "util",],
            url => $empty_url,
        },
        {
            l => "zvi_devir",
            d => "15/02",
            s => "Windows Refund HOWTO",
            t => ["advocacy",],
            url => "http://www.haifux.org/lectures/204/",
        },
        {
            l => "erez_d",
            d => "08/03",
            s => "Private Satellite T.V. and Linux",
            t => ["prog", "util",],
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_08_March_2009",
            'comments' => <<'EOF',
                <ul>
                <li>
                <a href="lecture-notes/Satellite-Television-and-Linux.pdf">Lecture
                Notes in PDF Format</a>
                </li>
                </ul>
EOF
        },
        {
            l => "szabgab",
            d => "22/03",
            s => "Introduction to Perl 6 - Part I",
            t => ["prog", "util","advocacy"],
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_22_March_2009",
        },
        {
            l => "szabgab",
            d => "05/04",
            s => "Introduction to Perl 6 - Part II",
            t => ["prog", "util","advocacy"],
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_05_April_2009",
        },
        {
            l => "alex_nerst_and_michal_geva",
            d => "31/05",
            s => "The Open-Source Fring Twitter and Last.fm Mobile Apps",
            t => ["prog"],
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_31_May_2009",
        },
        {
            l => "sawyer",
            d => "28/06",
            s => "Programming Red Flags",
            t => ["prog"],
            url => "http://www.slideshare.net/xSawyer/red-flags-1683319",
            comments => <<'EOF',
                <ul>
                <li>
                <a href="http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_21_June_2009">Meeting
                Page on the Wiki</a>
                </li>
                <li>
                <a href="lecture-notes/sawyer-programming-red-flags.odp">ODP
                File</a>
                </li>
                </ul>
EOF
        },
        {
            l => "david_khosid",
            d => "06/09",
            s => "Advanced GDB",
            t => ["prog"],
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_06_September_2009",
            comments => <<'EOF',
                <ul>
                <li>
                <a href="lecture-notes/GDB_Linux_telux.pdf">Slides in PDF Format</a>
                </li>
                <li>
                <a href="lecture-notes/GDB_Linux_telux.pptx">Slides in PPTX format</a> (New XML-based PowerPoint)
                </li>
                <li>
                <a href="lecture-notes/gdbinit_stl_views-1.03.txt">gdbinit STL
                views</a>
                </li>
                </ul>
EOF
        },
        {
            l => "conan",
            d => "25/10",
            s => "CMake",
            t => ["prog"],
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_25_October_2009",
            comments => <<'EOF',
EOF
        },
        {
            l => "tal_ko",
            d => "08/11",
            s => "Demo of Cool and Comprehensive Open Source Software",
            url => "http://wiki.osdc.org.il/index.php/Welcome_to_FOSS_-_2009",
            'series' => "w2foss-2009",
            t => ["advocacy"],
        },
        {
            l => "ori_idan",
            d => "22/11",
            s => "What is Free and Open Source Software?",
            'series' => "w2foss-2009",
            t => ["advocacy"],
            url => "http://wiki.osdc.org.il/index.php/Welcome_to_FOSS_-_2009",
            comments => <<"EOF",
            <p>
Ori Idan will talk about what actually
are free software and open-source: what are the guiding principles behind free
software, why is it good, important, and helpful for users (but also for
developers), and also why it doesn't contradict any Capitalistic principles.
Moreover, in this meeting, we will explore Linux as a 100% open source
operating system, and some things that its open-source nature enables.
</p>
<p>
<a href="lecture-notes/freesoftware.odp">Lecture Notes in OpenDocument Presentation Format</a> (OpenOffice.org, etc.)
</p>
EOF
        },
        {
            l => "tal_ko",
            d => "06/12",
            s => "Demo of Cool and Comprehensive Open Source Software",
            url => "http://wiki.osdc.org.il/index.php/Welcome_to_FOSS_-_2009",
            'series' => "w2foss-2009",
            t => ["advocacy"],
        },
    ],
    '2010' =>
    [
        {
            l => "sawyer",
            d => "17/01",
            s => q{The Moose Perl OOP System for Beginners - "Prepare for Total Moosification"},
            t => ["prog", "util",],
            url => "http://www.slideshare.net/xSawyer/moose-perl-5",
            comments => <<"EOF",
<p>
<a href="lecture-notes/moose-by-sawyer.odp">Copy of the Lecture Notes in OpenDocument Presentation Format</a> (OpenOffice.org, etc.)
</p>
EOF
        },
        {
            l => "drupal_il",
            d => "31/01",
            s => qq{"Drupal Israel" Tel Aviv January Meeting},
            t => ["prog", "util",],
            url => 'http://www.meetup.com/Drupal-Israel/calendar/12327179/?success=mailing_list_sent',
        },
        {
            l => "rami_addady",
            d => "14/02",
            s => "The vtiger CRM (= Customer Relation Management) Package",
            t => ["util", "advocacy",],
            url => $empty_url,
        },
        {
            l => "sawyer",
            d => "21/04",
            s => "Version Control Systems - What, Why and How",
            t => ["util", "advocacy",],
            url => "http://www.slideshare.net/xSawyer/source-code-management-systems",
            comments => <<"EOF",
<p>
<a href="lecture-notes/sawyer-vcs.odp">Copy of the Lecture Notes in OpenDocument Presentation Format</a> (OpenOffice.org, etc.)
</p>
EOF
        },
        {
            l => "ram_rachum",
            d => "22/07",
            s => "GarlicSim: an experimental tool for computer simulations",
            t => ["util", "prog",],
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_22_July_2010",
            comments => <<"EOF",
<ul>
<li><a href="http://garlicsim.org/">GarlicSim</a></li>
<li><a href="lecture-notes/GarlicSim-Presentation.ppt">Slides in PowerPoint Format (PPT)</a></li>
<li><a href="lecture-notes/GarlicSim-Presentation.otp">Slides in OpenDocument Format (OTP)</a></li>
</ul>
EOF
        },
        {
            l => "zohar_babin",
            d => "12/08",
            s => "Kaltura: The Open Source Video Platform",
            t => ["prog", "advocacy",],
            url => "http://wiki.osdc.org.il/index.php/Tel_Aviv_Meeting_on_12_August_2010",
            comments => <<"EOF",
<ul>
<li>
<a href="http://corp.kaltura.com/">Kaltura</a>
</li>
</ul>
EOF
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
            url => $empty_url,
            t => ["system", "net"],
        },

This is Ido Kanner's presentation about Optimising MySQL Queries:

        {
            l => "ido_kanner",
            d => "9/9",
            s => "Optimising MySQL Queries",
            url => $empty_url,
            t => ["prog"],
        },

=end Nothing

=cut

sub get_params
{
    return
        (
            'lecturer_aliases' => \%lecturer_aliases,
            'subject_render_callbacks' => \%subject_render_callbacks,
            'lecturers' => \%lecturers,
            'series_map' => \%series_map,
            'topics_map' => \%topics_map,
            'topic_aliases' => \%topic_aliases,
            'lectures' => \%lectures,
        );
}

1;

