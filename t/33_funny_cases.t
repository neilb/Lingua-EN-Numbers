#! perl

use strict;
use warnings;

use Test::More 0.88 tests => 1;
use Lingua::EN::Numbers qw/ num2en num2en_ordinal /;

my $number           = '1000000000000000000000000000000000000';
my $expected_ordinal = 'one times ten to the thirty-sixth';
my $ordinal          = num2en_ordinal($number);

is($ordinal, $expected_ordinal,
   "If the words for a number already end in 'th', then don't double up 'th' for the ordinal");
