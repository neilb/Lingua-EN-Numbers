use Test::More;
use warnings;
use strict;
use utf8;
use Lingua::EN::Numbers 'num2en';
my $wide = '１.２３';
my $out = num2en ($wide);
ok (! defined $out);
done_testing ();
