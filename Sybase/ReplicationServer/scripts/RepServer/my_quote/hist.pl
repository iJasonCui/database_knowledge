#!/usr/bin/perl

use Finance::QuoteHist;
$q = Finance::QuoteHist->new
     (
      symbols    => [qw(IBM UPS AMZN)],
      start_date => '01/01/2012', # or '1 year ago', see Date::Manip
      end_date   => 'today',
     );

# Quotes
foreach $row ($q->quotes()) {
    ($symbol, $date, $open, $high, $low, $close, $volume) = @$row;
    ...
}

# Splits
foreach $row ($q->splits()) {
     ($symbol, $date, $post, $pre) = @$row;
}

# Dividends
foreach $row ($q->dividends()) {
     ($symbol, $date, $dividend) = @$row;
}

# Culprit
$fetch_class = $q->quote_source('IBM');

