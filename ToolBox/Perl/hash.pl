#!/usr/bin/perl

use warnings;
use strict;

my %some_hash = ('foo', 35, 'bar', 12.4, 2.5, 'hello', 'wilma', 1.72e30, 'betty', "bye\n");

## The value of the hash (in a list context) is a simple list of key-value pairs:
my @any_array = %some_hash;

## Perl calls this unwinding the hash; turning it back into a list of key-value pairs. Of course,
## the pairs won’t necessarily be in the same order as the original list:
print "@any_array\n";

# might give something like this:
# betty bye (and a newline) wilma 1.72e+30 foo 35 2.5 hello bar 12.4

#-- big arrow
my %last_name = (
fred => 'flintstone',
barney => 'rubble',
betty => 'rubble',
);

#-- each function of hash

while ( my($key, $value) = each %last_name ) {
      print "$key => $value\n";
}

#-- foreach function

foreach my $key (sort keys %last_name) {
        print "$key => $last_name{$key}\n";
}

#--- exists function

if (exists $last_name{"betty"}) {
    print "There is last name betty\n";
}

#--- delete function

my $delete_person="betty";
delete $last_name{$delete_person};

while ( my($key, $value) = each %last_name ) {
      print "$key => $value\n";
}

#----

my %books = (
Jason   => 'The History Of Western',
Vincent => 'Thea Sister',
Juliana => 'Theory of Doctor',
Jason   => 'cooking boos',
);

my $person = 'Jason';

foreach $person (sort keys %books) { # each patron, in order
if ($books{$person}) {
    print "$person has $books{$person} items\n"; # fred has 3 items
   }
}

#----- the %ENV hash

print "PATH is $ENV{PATH}\n";


