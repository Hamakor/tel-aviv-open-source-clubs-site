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
    'aviram' =>
    {
        'name' => "Aviram Jenik",
        'name_render_type' => "email",
        'email' => "aviram\@beyondsecurity.com",
        'subject_render' => "series_idx",
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
    'dani_arbel' =>
    {
        'name' => "Dani Arbel",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
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
        'name_render_type' => "plain",
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
    'iftach_hyams' =>
    {
        'name' => "Iftach Hyams",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
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
        'subject_render' => "series_idx",
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
    'oded_koren' =>
    {
        'name' => "Oded Koren",
        'name_render_type' => "plain",
        'subject_render' => "no_url",
    },
    'oleg' =>
    {
        'name' => "Oleg Goldshmidt",
        'name_render_type' => "email",
        'email' => "pub\@goldshmidt.org",
        'subject_render' => "series_idx",
    },
    'orna' =>
    {
        'name' => "Orna Agmon",
        'name_render_type' => "homepage",
        'subject_render' => "series_idx",
        'homepage' => "http://tx.technion.ac.il/~agmon/",
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
    'shimon_panfil' =>
    {
        'name' => "Shimon Panfil, Ph.D.",
        'name_render_type' => "plain",
        'subject_render' => "series_idx",
    },
    'shlomif' =>
    {
        'name' => "Shlomi Fish",
        'name_render_type' => "email",
        'email' => "shlomif\@vipe.technion.ac.il",
        'subject_render' => "shlomif",
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
        'name_render_type' => "email",
        'email' => "haifux\@shemesh.biz",
        'subject_render' => "series_idx",
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
    'advo' => "advocacy",
);

%lectures = 
(
    '1999' =>
    [
        {
            'l' => "choo",
            's' => "Introduction to Linux",
            'd' => "19/8",
            't' => [],
        },
        {
            'l' => "choo",
            's' => "Robust Programming",
            'd' => "9/9",
            't' => "prog",
        },
        {
            'l' => "choo",
            's' => "PAM (Pluggable Authentication Management)",
            'd' => "23/9",
            't' => [qw(security utils system)],
        },
        {
            'l' => "orrd",
            's' => "Linux Security",
            'd' => "21/10",
            't' => "security",
        },
        {
            'l' => "choo",
            's' => "PAM (Pluggable Authentication Management) - Writing PAM Modules",
            'd' => "4/11",
            't' => [qw(security utils system)],
            'comments' => qq{<ul>
	 <li><a href="http://www.csn.ul.ie/~airlied/pam_smb">A PAM Module
for NT Connectivity</a></li>
	 <li><a href="http://us1.samba.org/samba/ftp/pam_ntdom">A Samba
Based PAM</a></li>
      </ul>},      
        },
        {
            'l' => "asaf_arbely",
            's' => "Universal Servers - Architecture, Availability and Usage. The plaftorm is... Informix",
            'd' => "18/11",
            't' => "utils",
            'comments' => <<'EOF',
        <ul>
	 <li><a href="http://www.informix.com/iif2000/">Informix Internet
Foundation 2000</a></li>
         <li><a
href="http://www.informix.com/informix/products/linux/">Informix on
Linux</a></li>
         <li><a href="http://www.informix.com/idn">Informix Developers
Network</a></li>
	 <li><a
href="http://www.informix.com/informix/press/1999/nov99/redhat.htm">Informix
and RedHat</a></li>
       </ul>
EOF
                ,
        },
        {
            'l' => "choo",
            's' => "Introduction to Sockets Programming",
            'd' => "28/11",
            't' => [qw(prog network system)],
            'comments' => qq{Based on <a href="http://www.actcom.co.il/~choo/lupg/tutorials/internetworking/internet-theory.html">LUPG's internet programming tutorial</a>},
        },
        {
            'l' => "oded_koren",
            's' => "Introducing the Linux World to Outsiders",
            'd' => "12/12",
            't' => "advocacy",
        },
        {
            'l' => "choo",
            's' => "Advanced Socket Programming",
            'd' => "26/12",
            't' => [qw(prog network system)],
            'comments' => qq{Based on <a href="http://www.actcom.co.il/~choo/lupg/tutorials/internetworking/internet-theory.html">LUPG's internet programming tutorial</a><br />
    <ul>
	<li><a href="http://www.acme.com/software/mini_httpd/">Mini-httpd,
httpd using the fork model</a></li>
	<li><a href="http://mathop.diva.nl">Mathopd, single process,
single thread, httpd</a></li>
    </ul>
            },
        },  
    ],
    '2000' =>
    [
        {
            'l' => "orrd",
            's' => "Kerberos Authentication Protocol",
            'd' => "9/1",
            't' => [qw(security network)],
            'comments' => qq{
<ul>
	<li><a href="ftp://ftp.isi.edu/in-notes/rfc1411.txt">RFC 1411
(Kerberos 4)</a></li>
	<li><a href="ftp://ftp.isi.edu/in-notes/rfc1510.txt">RFC 1510
(Kerberos 5)</a></li>
	<li><a href="http://ptolemy.eecs.berkeley.edu/~cxh/krb/">Kerberos
Data (User, Administrator, etc.)</a></li>
	<li><a href="http://www.cs.technion.ac.il/~cs236350">Computer
Security Course at the Technion</a></li>
	<li><a href="lecture/10/kerberos.ps">Kerberos Version 4 short
explanation (NOT an RFC)</a></li>
       </ul>
    },
        },
        {
            'l' => "shimon_panfil",
            's' => "High Performance Computing on Linux",
            'd' => "23/1",
            't' => [],
            'comments' => qq{
                <ul>
	<li><a href="http://www.cs.huji.ac.il/labs/mosix">MOSIX (Made in
Israel)</a></li>
	<li><a href="http://www.pobox.com/~kragen/beowulf-faq.txt">
BeoWulf FAQ</a></li>
       </ul>
            },
            'url' => "11/hpcl.ps",
        },
        {
            'l' => "choo",
            's' => "Linux Startup Process - from Boot till SysV Init",
            'd' => "6/2",
            't' => [qw(kernel system)],
            'comments' => qq{<a href="http://193.6.40.1/~cellux/pc-guide/mbr_asm_eng.html">Contents of a Master Boot Record</a>},            
        },
        {
            'l' => "choo",
            's' => "Linux Runtime Environment",
            'd' => "5/3",
            't' => [qw(prog system)],
            'comments' => qq{<ul>
	<li><a
href="http://gazette.euskal-linux.org/issue23/flower/page1.html">Processes
on Linux and Windows NT</a></li>
	<li><a
href="http://www.erlenstar.demon.co.uk/unix/faq_2.html">Unix Programming
FAQ - Process control</a></li>
       </ul>},
        },
        {
            'l' => "shlomif",
            's' => "The PostgreSQL Relational Database Server",
            'd' => "2/4",
            't' => [qw(utils prog)],
            'url' => "PostgreSQL-Lecture/",
        },
        {
            'l' => "orrd",
            's' => "The Page Daemon",
            'd' => "16/4",
            't' => [qw(kernel system)],
            'comments' => qq{
      <ul>
	<li><a href =
"http://www.cs.technion.ac.il/Courses/Operating-Systems-Structure">Operating
systems structure course</a></li>
	<li>Kernel Code - shm.*, mem*.[c,h], ptable*.[c,h,asm] :)</li>
	<li><a href=
"http://www.bell-labs.com/topic/books/os-book/slide-dir/slide-ps.html">Operating
System Concepts</a> chapters 21, 22.</li>
       </ul>
            },
            'subject_render' => "no_url",
        },
        {
            'l' => "choo",
            's' => "Network Protocols (routing, etc)",
            'd' => "7/5",
            't' => "network",
            'url' => "16+18/index.html",
        },
        {
            'l' => "shlomif",
            's' => "The Scheme Programming Language and Lambda Calculus",
            'd' => "28/5",
            't' => "prog",
            'url' => "Lambda-Calculus/",
        },
        {
            'l' => "choo",
            's' => "Network Protocols pt. II - Routing and Higher Level Protocols",
            'd' => "11/6",
            't' => "network",
            'url' => "16+18/index2.html",
            'comments' => qq{<a href="http://rfc.roxen.com/rfc/rfc1771.html">RFC 1771 - BGP 4 protocol</a>},
        },
        {
            'l' => "choo",
            's' => "Advnaced Networking Administration",
            'd' => "25/6",
            't' => "network",
        },
        {
            'l' => "orrd",
            's' => "Introduction to Real Life Administration",
            'd' => "9/7",
            't' => "security",
        },
        {
            'l' => "orrd",
            's' => "Advanced Real Life Administration",
            'd' => "24/7",
            't' => "security",
            'url' => "21/2nd-admin.ps",
        },
        {
            'l' => "choo",
            's' => "Kernel Hacking",
            'd' => "7/8",
            't' => [qw(kernel prog)],
        },
        {
            'l' => "choo",
            's' => "CORBA - Theory before Practice",
            'd' => "24/8",
            't' => [qw(prog network)],
            'comments' => qq{
<ul>
	<li><a href="http://www.cs.wustl.edu/~schmidt/TAO.html">TAO - The
ACE Orb</a></li>
	<li><a href="http://www.icsi.berkeley.edu/~mico">MICO - Mico Is
COrba</a></li>
      </ul>
            },            
        },
        {
            'l' => "orrd",
            's' => "SED - The Stream Editor",
            'd' => "11/9",
            't' => "utils",
            'comments' => qq{<a href ="http://www.dbnet.ece.ntua.gr/~george/sed/sedtut_1.html">Do it with SED</a>},
        },
        {
            'l' => "choo",
            's' => "CORBA Programming - Simple Clients and Servers",
            'd' => "25/9",
            't' => [qw(prog network)],
            'comments' => qq{<a href="http://www.cuj.com/experts/1811/vinoski.html">_var and _ptr</a>},
        },
    ],
    '2001' =>
    [
        {
            'l' => "eli",
            's' => "Demistifying Boot Diskettes",
            'd' => "8/1",
            't' => ["system"],
        },
        {
            'l' => "mulix",
            's' => "Daemons and Other Monsters",
            'd' => "22/1",
            't' => [qw(prog system)],
            'comments' => qq{<a href="http://www.mulix.org/">Mulix' Site</a>},
        },
        {
            'l' => "choo",
            's' => "Development Tools for Linux",
            'd' => "12/2",
            't' => [qw(prog utils)],
        },
        {
            'l' => "orrd",
            's' => "All you need is LaTeX",
            'd' => "19/2",
            't' => "utils",
        },
        {
            'l' => "alon",
            's' => "Burning CDs under Linux",
            'd' => "5/3",
            't' => "utils",
        },
        {
            'l' => "tzafrir",
            's' => "RPMs - Meaning of the Package",
            'd' => "19/3",
            't' => [qw(utils system)],
        },
        {
            'l' => "shlomif",
            's' => "Intro to Programming in Perl",
            'd' => "26/3",
            'series' => "perl",
            't' => "prog",
            'url' => "Perl/Newbies/lecture1/",
        },
        {
            'l' => "choo",
            's' => "Development Tools for Linux - Part II",
            'd' => "2/4",
            't' => [qw(prog utils)], 
            'url' => "28/",
        },
        {
            'l' => "shlomif",
            's' => "Intro to Programming in Perl",
            'd' => "16/4",
            'series' => "perl",
            't' => "prog",
            'url' => "Perl/Newbies/lecture2/",
        },
        {
            'l' => "alon",
            's' => "Multimedia in Linux",
            'd' => "23/4",
            't' => "utils",
            'comments' => qq{<a href="lectures/33/shlomif_remarks.txt">Shlomi Fish's errata and comments</a>},
        },
        {
            'l' => "choo",
            's' => "Gtk+ (part I)",
            'd' => "7/5",
            't' => "prog",
            'url' => "34+35/",
        },
        {
            'l' => "choo",
            's' => "Gtk+ (part II)",
            'd' => "21/5",
            't' => "prog",
            'url' => "34+35/",
        },
        {
            'l' => "choo",
            's' => "GUI design (Gtk+ part III)",
            'd' => "4/6",
            't' => "prog",
            'url' => "36/",
        },
        {
            'l' => "choo_and_eli",
            's' => "GUI part IV - Gtk+ and Perl",
            'd' => "18/6",
            't' => "prog",
            'url' => "34+35/",
            'comments' => qq{<a href="http://www.geocities.com/eli_billauer/ptk.html">Examples for Perl GUI</a>},
        },
        {
            'l' => "shlomif",
            's' => "GIMP",
            'd' => "16/7",
            't' => "utils",
            'url' => "Gimp/",
        },
        {
            'l' => "shlomif",
            's' => "GIMP (part II)",
            'd' => "13/8",
            't' => "utils",
            'url' => "Gimp/",
        },
        {
            'l' => "mulix",
            's' => "ADSL for Linux - War Story",
            'd' => "27/8",
            't' => "network",
            'comments' => qq{<a href="http://www.mulix.org/">The ADSL-HOWTO and patched pptps</a>},
        },
        {
            'l' => "ez-aton",
            's' => "KickStart and Mass Linux Production",
            'd' => "10/9",
            't' => "utils",
        },
        {
            'l' => "orrd",
            's' => "SSL - the Protocol, the Package and the CA",
            'd' => "24/9",
            't' => [qw(security network)],
        },
        {
            'l' => "shlomi_loubaton",
            's' => "PHP",
            'd' => "15/10",
            't' => "prog",
        },
        {
            'l' => "mulix_and_choo",
            's' => "Syscalltrack - Design and Implementation",
            'd' => "24/12",
            't' => [qw(kernel prog)],
            'comments' => qq{<a href="http://syscalltrack.sf.net/">Syscalltrack Homepage</a><br />
       <a href="lectures/22/">Kernel hacking lecture (#22)</a>},
        },
    ],
    '2002' =>
    [
        {
            'l' => "dani_arbel",
            's' => "Advanced Networking - IP Tables",
            'd' => "8/1",
            't' => [qw(network security)],
        },
        {
            'l' => "dani_arbel",
            's' => "Advanced Networking - Routing and VPNs",
            'd' => "22/1",
            't' => [qw(network security)],
            'comment' => qq{<a href="http://damyen.technion.ac.il/~dani">Dani Arbel's Lectures and Examples</a>},
        },
        {
            'l' => "shlomif",
            's' => "The Scheme Programming Language and Lambda Calculus - Rerun (Lecture #17)",
            'd' => "4/2",
            't' => "prog",
            'url' => "Lambda-Calculus/",
        },
        {
            'l' => "orrd",
            's' => "The new Anti-Linux US Laws (DMCA, UCITA)",
            'd' => "18/2",
            't' => "advocacy",
            'comments' => qq{<a href="lectures/48/dmca_song">The DMCA song</a>},
        },
        {
            'l' => "alon",
            's' => "Using Linux in a Windows World",
            'd' => "4/3",
            't' => [qw(utils system)],
        },
        {
            'l' => "mulix",
            's' => "Python",
            'd' => "18/3",
            't' => "prog",
        },
        {
            'l' => "choo",
            's' => "POSIX Threads - Primitives (part I)",
            'd' => "8/4",
            't' => "prog",
        },
        {
            'l' => "choo",
            's' => "POSIX Threads - Threading Modules (part II)",
            'd' => "22/4",
            't' => "prog",
            'url' => "52+53/",
        },
        {
            'l' => "choo",
            's' => "POSIX Threads - Threading Modules (part III)",
            'd' => "20/5",
            't' => "prog",
            'url' => "52+53/",
        },
        {
            'l' => "shlomif",
            's' => "Freecell Solver",
            'd' => "3/6",
            't' => "prog",
            'url' => "Freecell-Solver/",
            'comments' => qq{<ul>
         <li><a href="http://www.advogato.com/person/shlomif/diary.html?start=44">Shlomi's thoughts about the lecture</a></li>
	 <li><a href="http://vipe.technion.ac.il/~shlomif/freecell-solver/">Freecell Solver's Homepage</a></li>
       </ul>},
        },
        {
            'l' => "alon",
            's' => "How to Burn CDs in Linux and Remain Sane",
            'd' => "8/7",
            't' => "utils",
            'comments' => qq{<a href="lectures/30">Rerun lecture (30)</a>},
        },
        {
            'l' => "shlomif",
            's' => "Intro to Programming in Perl",
            'd' => "22/7",
            'series' => "perl",
            't' => "prog",
            'url' => "Perl/Newbies/lecture3/",
        },
        {
            'l' => "shlomif",
            's' => "Intro to the GNU Autoutils",
            'd' => "5/8",
            't' => "prog",
            'url' => "Autoutils/slides/",
        },
        {
            'l' => "orrd",
            's' => "Promoting Linux - The Marketing Approach",
            'd' => "19/8",
            't' => "advocacy",
        },
        {
            'l' => "choo",
            's' => "Strace and Ltrace Behaviour",
            'd' => "30/9",
            't' => [qw(utils system)],
        },
        {
            'l' => "nadav_rotem",
            's' => "The GNOME-2 Desktop + Developing GTK Applications with GLADE2",
            'd' => "14/10",
            't' => [qw(prog utils)],
            'comments' => qq{<ul>
<li><a href="http://gaia.ecs.csus.edu/~rotemn/GPMM/GPMM.html">GPMM2
for GNOME2</a></li>
<li><a href=
"http://gaia.ecs.csus.edu/~rotemn/shop/shop.html">Example of
application to GNOME2</a></li>
</ul>},
        },
        {
            'l' => "mark_silberstein",
            's' => "High Performance Computing in Linux",
            'd' => "9/12",
            't' => "network",
        },
        {
            'l' => "gby",
            's' => "The Dynamic Linker",
            'd' => "23/12",
            't' => [qw(prog system)],
            'url' => "http://www.benyossef.com/presentations/dlink/",
        },
    ],
    '2003' =>
    [
        {
            'l' => "dan_kenigsberg",
            's' => "Hspell - The First GPLed Hebrew Spell Checker",
            'd' => "6/1",
            't' => [qw(prog utils)],
            'url' => "http://www.cs.technion.ac.il/~danken/hspell/lecture.html",
            
        },
        {
            'l' => "mulix",
            's' => "Kernel Hacking",
            'd' => "20/1",
            't' => [qw(kernel prog)],
        },
        {
            'l' => "meir_maor",
            's' => "Emacs Power Usage",
            'd' => "3/2",
            't' => "utils",
        },
        {
            'l' => "sun",
            's' => "Secure Programming (Part I)",
            'd' => "17/2",
            't' => [qw(prog security)],
            'subject_render' => "no_url",
        },
        {
            'l' => "sun",
            's' => "Secure Programming (Part II)",
            'd' => "3/3",
            't' => [qw(prog security)],
            'subject_render' => "no_url",
        },
        {
            'l' => "orrd",
            's' => "Boot Loaders for All!",
            'd' => "17/3",
            't' => [qw(system)],
            'comments' => <<EOF,
<ul>
<li>
<a href="http://www.haifux.org/lectures/67/mbr.txt">Contents of Master Boot Record</a>
</li>
<li>
<a href="http://www.haifux.org/lectures/67/mbr-disassembly.txt">Contents of MBR
in Assembly</a>
</li>
</ul>
EOF
        },
        {
            'l' => "choo",
            's' => "Linux Memory Allocators",
            'd' => "31/3",
            't' => [qw(kernel prog)],
        },
        {
            'l' => "aviram",
            's' => "Security Auditing",
            'd' => "14/4",
            't' => [qw(security)],
        },
        {
            'l' => "eli",
            's' => "IP Masquerading using IP-Tables",
            'd' => "28/4",
            't' => [qw(network)],
        },
        {
            'l' => "oleg",
            's' => "Scaling *Way* Up",
            'd' => "12/5",
            't' => [qw(prog)],
        },
        {
            'l' => "orna",
            's' => "Portability Programming",
            'd' => "26/5",
            't' => [qw(prog)],
        },
        {
            'l' => "eli",
            's' => "The Eobj Perl Environment",
            'd' => "9/6",
            't' => [qw(prog)],
        },
        {
            'l' => "sun",
            's' => "WINE",
            'd' => "23/6",
            't' => [qw(prog system)],
            'subject_render' => "no_url",
        },
        {
            'l' => "mulix",
            's' => "From Python Import Lecture",
            'd' => "7/7",
            't' => [qw(prog util)],
            'comments' => <<EOF,
Re-run of <a href="./lectures/50/">lecture #50</a>
EOF
        },
        {
            'l' => "moshez",
            's' => "Python and Twisted",
            'd' => "21/7",
            't' => [qw(prog util)],
            'url' => "http://twistedmatrix.com/~moshez/haifux.html",
        },
        {
            'l' => "mulix",
            's' => "OLS 2003",
            'd' => "4/8",
            't' => [qw(kernel)],
            'subject_render' => "explicit_url",
            'url' => "http://www.linuxsymposium.org/",
        },
        {
            'l' => "iftach_hyams",
            's' => "Real Time in Linux",
            'd' => "18/8",
            't' => [qw(system kernel)],
        },
        {
            'l' => "haifux_members",
            's' => "Arranging the W2L and InstaParty",
            'd' => "25/8",
            'series' => "none",
            't' => [],
        },
        {
            'l' => "oleg",
            's' => "Pseudo-, Quasi-, and Real Random Numbers",
            'd' => "1/9",
            't' => [qw(prog)],
        },
        {
            'l' => "shimon_panfil",
            's' => "Tcl/Tk",
            'd' => "15/9",
            't' => [qw(prog util)],
        },
        {
            'l' => "ron_art",
            's' => "Mulitilingual Typesetting",
            'd' => "29/9",
            't' => [qw(util)],
        },
        {
            'l' => "aviram",
            's' => "SPAM - Everyone's Favorite Food",
            'd' => "15/12",
            't' => [qw(network)],
            'subject_render' => "no_url",
        },
        {
            'l' => "orrd",
            's' => "SMTP and qmail",
            'd' => "29/12",
            't' => [qw(network util)],
            'subject_render' => "no_url",
        },
    ],
    '2004' =>
    [
        {
            'l' => "choo",
            's' => "UNIX's basics: Users, Processes, Permissions and What's Between Them",
            'd' => "5/1",
            't' => [qw(system)],
            'comments' => "<p>In Two Parts</p>",
            'sub-series' => "SiL",
            'url' => "084-sil/",
        },
        {
            'l' => "alon",
            's' => "Proxying - why and how",
            'd' => "12/1",
            't' => [qw(network)],
        },
        {
            'l' => "choo",
            's' => "Kernel, Modules, Drivers",
            'd' => "19/1",
            't' => [qw(system kernel)],
            'comments' => "In two parts",
            'url' => "86-sil/",
        },
        {
            'l' => "eran_sandler",
            's' => "The mono Project",
            'd' => "26/1",
            't' => [qw(system prog)],
            'comments' => qq{<p>See <a href="http://www.go-mono.com/">Mono</a></p>},
        },
        {
            'l' => "choo",
            's' => "Kernel, Modules, Drivers - Part II",
            'd' => "2/2",
            't' => [qw(kernel system)],
            'url' => "88-sil/",
            'sub-series' => "SiL",
        },
        {
            'l' => "mulix",
            's' => "Linux Device Drivers",
            'd' => "9/2",
            'url' => "http://www.mulix.org/klife.html",
            't' => [qw(kernel)],
            'subject_render' => "explicit_url",
        },
        {
            'l' => "alon",
            's' => "Multimedia in Linux",
            'd' => "16/2",
            'sub-series' => "SiL",
            'subject_render' => "no_url",
            't' => [qw(util system)],
        },
        {
            'l' => "ron_art",
            's' => "Multilingual TeX",
            'd' => "23/2",
            't' => [qw(util)],
            'comments' => qq{A sequel to <a href="./lectures/81/">Multilingual Typesetting</a>},
            'subject_render' => "no_url",
        },
        {
            'l' => "orna",
            's' => "Working with the UNIX Shell",
            'd' => "1/3",
            't' => [qw(system)],
            'subject_render' => "no_url",
            'sub-series' => "SiL",
        },
        {
            'l' => "you",
            's' => "Open Slot",
            'd' => "8/3",
            't' => [],
            'subject_render' => "no_url",
        },
        {
            'l' => "tzahi_fadida",
            's' => "CVS",
            'd' => "15/3",
            't' => [qw(prog util)],
            'sub-series' => "SiL",
            'url' => "94-sil/",
        },
        #{
        #    'l' => "mulix",
        #    's' => "UML - User Mode Linux",
        #    'd' => "21/6",
        #    't' => [qw(kernel system prog)],
        #    'subject_render' => "no_url",
        #}
    ],
);

