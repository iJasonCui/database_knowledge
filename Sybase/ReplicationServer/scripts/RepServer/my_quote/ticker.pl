#!/usr/bin/perl -w
#
# Example stock-ticker program.  Can look up stocks from multiple
# markets and return the results in local currency.
#
# Revision: 1.1 

use strict;
use Finance::Quote;

my $CURRENCY = "CAD";	# Set preferred currency here, or empty string for
			# no conversion.

# The stocks array contains a set of array-references.  Each reference
# has the market as the first element, and a set of stocks thereafter.

my @STOCKS = ([qw/canada HND SLW ECA TCK.B/],
	      [qw/usa MSFT FB AAPL SAP/]
	     );

# These define the format.  The first item in each pair is the label,
# the second is the printf-style formatting, the third is the width
# of the field (used in printing headers).

my @labels = (["name",  "%12s",  15],
	      ["date",  "%11s",  11], 
	      ["time",  "%10s",  11],
	      ["last",  "%8.2f",  8],
	      ["high",  "%8.2f",  8], 
	      ["low",   "%8.2f",  8],
	      ["close", "%8.2f",  8], 
	      ["volume","%10d",  10]);

my $REFRESH = 120;	# Seconds between refresh.

# --- END CONFIG SECTION ---

my $quoter = Finance::Quote->new();
my $clear  = `clear`;			# So we can clear the screen.

# Build our header.

my $header = "\t\t\t\tSTOCK REPORT" .($CURRENCY ? " ($CURRENCY)" : "") ."\n\n";

foreach my $tuple (@labels) {
	my ($name, undef, $width) = @$tuple;
	$header .= sprintf("%".$width."s",uc($name));
}

$header .= "\n".("-"x79)."\n";

# Header is all built.  Looks beautiful.

$quoter->set_currency($CURRENCY) if $CURRENCY;	# Set default currency.

for (;;) {	# For ever.
	print $clear,$header;

	foreach my $stockset (@STOCKS) {
		my ($exchange, @symbols) = @$stockset;
		my %info = $quoter->fetch($exchange,@symbols);

		foreach my $symbol (@symbols) {
			next unless $info{$symbol,"success"}; # Skip failures.
			foreach my $tuple (@labels) {
				my ($label,$format) = @$tuple;
				printf $format,$info{$symbol,$label};
			}
			print "\n";
		}
	}

	sleep($REFRESH);
}

__END__

