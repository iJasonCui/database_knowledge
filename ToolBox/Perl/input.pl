#!/usr/bin/perl

$madonna = <STDIN>;
chomp $madonna;

$madonna = undef;

if ( defined($madonna) ) {
        print "The input was $madonna";
} else {
        print "No input available!\n";
}
