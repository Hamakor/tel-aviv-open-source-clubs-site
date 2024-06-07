#!/bin/bash

set -x
set -o pipefail

export XML_CATALOG_FILES="/etc/xml/catalog $HOME/markup-validator/htdocs/sgml-lib/catalog.xml"
export PATH="$PWD/node_modules/.bin:$PATH:/usr/games"
export SKIP_SPELL_CHECK=",en,"
export MAKEFLAGS="-r"

if ! cd "wml"
then
    printf "Cannot cd to '%s'!" "wml"
    exit -1
fi

m()
{
    gmake DBTOEPUB="${DBTOEPUB:-/usr/bin/ruby $(which dbtoepub)}" \
        DOCBOOK5_XSL_STYLESHEETS_PATH=/usr/share/xml/docbook/stylesheet/docbook-xsl-ns \
    "$@"
}

# For inkscape: job no. 1
xserver_for_inkscape()
{
    Xvfb :1 -screen 0 1920x1200x24 &
    export DISPLAY=":1.0"
}
# xserver_for_inkscape
if ! ./gen-helpers ; then
    echo "Error in executing ./gen-helpers" 1>&2
    exit -1
fi

if ! m 2>&1 ; then
    echo "Error in executing make." 1>&2
    exit -1
fi

test_target='test'
if false
then
    export HARNESS_VERBOSE=1
    if test -n "$HARNESS_PLUGINS"
    then
        unset HARNESS_PLUGINS
    fi
    test_target='runtest'
fi
stop_xserver_for_inkscape()
{
    kill %1
    unset DISPLAY
}
# stop_xserver_for_inkscape
if ! m $test_target ; then
    echo "Error in executing make $test_target." 1>&2
    exit -1
fi
