
TARGET = dest

WML_FLAGS += -DLATEMP_THEME=perl-begin-1 -DLATEMP_SERVER=berlios

LATEMP_WML_INCLUDE_PATH =$(shell latemp-config --wml-include-path)

WML_FLAGS += --passoption=2,-X3074 --passoption=3,-I../lib/ \
	--passoption=3,-w -I$(LATEMP_WML_INCLUDE_PATH) -I../ -DROOT~. \
	-I../lib/ --passoption=7,"-S imgsize"

RSYNC = rsync --progress --verbose --rsh=ssh 

DOCS_COMMON_DEPS = template.wml

all: latemp_targets

include include.mak
include rules.mak

upload: upload_berlios
