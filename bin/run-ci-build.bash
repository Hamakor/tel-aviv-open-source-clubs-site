#! /bin/bash
#
# run-ci-build.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
set -e
set -x
bash -x bin/travis-ci-script.bash
# find dest/post-incs/t2/ -type f | (LC_ALL=C sort) | head -500 | xargs sha256sum
