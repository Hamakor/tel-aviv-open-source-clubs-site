
TARGET = dest

# PAGES = about articles/index books/index core-doc/index index irc/index mailing-lists/index links/index site-resources/index tutorials/index web-forums/index

# SUBDIRS = articles books core-doc irc links mailing-lists tutorials site-resources source source/arcs web-forums

include defs.mak


SOURCES = $(addprefix src/,$(addsuffix .html.wml,$(PAGES)))

DESTS = $(patsubst src/%.html.wml,$(TARGET)/%.html,$(SOURCES))

RAW_FILES = $(IMAGES)
RAW_FILES_SOURCES = $(addprefix src/,$(RAW_FILES))
RAW_FILES_DEST = $(addprefix $(TARGET)/,$(RAW_FILES))

PODS = $(addprefix docs/,roadmap spec whitepaper version-0.2-spec)
PODS_DESTS_HTMLS = $(patsubst %,$(TARGET)/%.html,$(PODS))
PODS_DESTS_PODS = $(patsubst %,$(TARGET)/%.pod,$(PODS))

# PACKAGES_DIR = $(TARGET)/download/arcs
# PACKAGES = $(shell cd temp && cd lk-module-compiler-final && ls)
# PACKAGES_DESTS = $(addprefix $(PACKAGES_DIR)/,$(PACKAGES))

SUBDIRS_DEST = $(addprefix $(TARGET)/,$(SUBDIRS))

WML_FLAGS += --passoption=2,-X --passoption=3,-I../lib/ --passoption=7,"-S imgsize" -DROOT~. --passoption=2,--encoding=utf8

RSYNC = rsync --progress --verbose --rsh=ssh 

LIBRARY_FILES = template.wml lib/MyNavData.pm

# This is a file that does not change or is timestamped from invocation
# to inovcation of this makefile. Useful for synchronizing uploads.
UNCHANGED_FILE = unchanged

all: dest $(SUBDIRS_DEST) $(DESTS) $(RAW_FILES_DEST)

$(UNCHANGED_FILE):
	touch $@

dest:
	if [ ! -e $@ ] ; then mkdir $@ ; fi
	
$(DESTS) :: $(TARGET)/% : src/%.wml $(LIBRARY_FILES)
	(cd src && wml $(WML_FLAGS) -DFILENAME=$(patsubst src/%.wml,%,$<) $(patsubst src/%,%,$<)) > $@

$(RAW_FILES_DEST) :: $(TARGET)/% : src/%
	cp -f $< $@

$(SUBDIRS_DEST) :: % : $(UNCHANGED_FILE)
	if [ ! -e $@ ] ; then mkdir $@ ; fi



$(PODS_DESTS) :: $(TARGET)/% : src/%
	cp -f $< $@

$(PODS_DESTS_HTMLS) :: $(TARGET)/%.html : src/%.pod
	pod2html $< > $@

# $(PACKAGES_DESTS) :: $(PACKAGES_DIR)/% : ./temp/lk-module-compiler-final/%
# 	cp -f $< $@

upload: upload_telux_new

upload_telux_new: all
	(cd dest && $(RSYNC) -r * shlomif@penguin.cs.tau.ac.il:/vol/web/www-cs/telux/New-Site/)

.PHONY:
