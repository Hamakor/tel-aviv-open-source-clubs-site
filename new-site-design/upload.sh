#!/bin/sh
rsync --rsh=ssh -v --progress -a * shlomif@penguin.cs.tau.ac.il:/vol/web/www-cs/telux/Site-Hadash/
