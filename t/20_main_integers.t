
require 5;
# Time-stamp: "2005-01-01 16:55:42 AST"
use strict;
use Test;

BEGIN { plan tests => 18, todo => [13 .. 17] }

use Lingua::EN::Numbers;
ok 1;

print "# Using Lingua::EN::Numbers v$Lingua::EN::Numbers::VERSION\n";

sub N { Lingua::EN::Numbers->new($_[0])->get_string }

ok N(0), "Zero";
ok N('0'), "Zero";
ok N('-0'), "Zero";
ok N('0.0'), "Zero";
ok N('.0'), "Zero";
ok N(1), "One";
ok N(2), "Two";
ok N(3), "Three";
ok N(4), "Four";
ok N(40), "Forty";
ok N(42), "Forty-Two";


ok N(400), "Four Hundred";
ok N('.1'), "point One";
ok N('.1'), "point Zero One";

ok N('.1'), "point One";
ok N('.1'), "point Zero One";


ok N('4003'), "Four Thousand, Three";
