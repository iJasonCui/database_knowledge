#!/usr/bin/perl

use strict;

if ( ! open LOG, '>>', 'logfile' ) {
die "Cannot create logfile: $!";
}

open LOG, '>>', 'logfile';

open my $rocks_fh, '>', 'rocks.txt'
        or die "Could not open rocks.txt: $!";
foreach my $rock ( qw( slate lava granite ) ) {
print  $rocks_fh "$rock \n";
}
