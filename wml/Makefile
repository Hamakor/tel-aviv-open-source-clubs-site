
TARGET = dest

WML_FLAGS += -DLATEMP_THEME=perl-begin-1 -DLATEMP_SERVER=berlios

LATEMP_WML_INCLUDE_PATH =$(shell latemp-config --wml-flags)

WML_FLAGS += --passoption=2,-X3074 --passoption=3,-I../lib/ \
	--passoption=3,-w $(LATEMP_WML_INCLUDE_PATH) -I../ -DROOT~. \
	-I../lib/ --passoption=7,"-S imgsize"

RSYNC = rsync --progress --verbose --rsh=ssh 

DOCS_COMMON_DEPS = template.wml

all: latemp_targets dest/Default.html dest/rss.xml

lib/lectures_dest/rss.xml lib/lectures_dest/%.html: lib/render_lectures.pl lib/LecturesData.pm
	(cd lib && perl render_lectures.pl)

src/advanced-2004.html.wml: lib/lectures_dest/2003.html lib/lectures_dest/2004.html
	touch $@

src/advanced.html.wml: lib/lectures_dest/2005.html lib/lectures_dest/2006.html lib/lectures_dest/2007.html
	touch $@

src/newbies.html.wml: lib/lectures_dest/w2l-2005.html
	touch $@

src/index.html.wml: lib/lectures_dest/future.html
	touch $@

dest/Default.html: dest/index.html
	cp -f $< $@

dest/rss.xml: lib/lectures_dest/rss.xml
	cp -f $< $@

include include.mak
include rules.mak

upload: upload_telux

upload_telux_new: all
	(cd dest && $(RSYNC) -r * shlomif@penguin.cs.tau.ac.il:/vol/web/www-cs/telux/New-Site/)

upload_telux: all
	(cd dest && $(RSYNC) -r * shlomif@penguin.cs.tau.ac.il:/vol/web/www-cs/telux/)

test:
	prove -l t/*.t

runtest:
	runprove -l t/*.t

