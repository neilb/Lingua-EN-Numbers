#!perl
use strict;
use warnings;

use Test::More tests => 2;

use bigint;
use Lingua::EN::Numbers qw(num2en);

T(10 ** 1000,    'ten times ten to the nine hundred and ninety-ninth');
T(2 ** 65, 'thirty-six quintillion, eight hundred and ninety-three quadrillion, four hundred and eighty-eight trillion, one hundred and forty-seven billion, four hundred and nineteen million, one hundred and three thousand, two hundred and thirty-two');

sub T
{
    my $number   = shift;
    my $expected = shift;
    my $generated;

    $generated = num2en($number);
    ok($generated eq $expected, "converting $number");
}
