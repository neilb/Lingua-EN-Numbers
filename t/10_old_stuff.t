
require 5;
# Time-stamp: "2003-10-14 18:04:28 ADT"
use strict;
use Test;

BEGIN { plan tests => 2 }

use Lingua::EN::Numbers;
ok 1;
print "# Using Lingua::EN::Numbers v$Lingua::EN::Numbers::VERSION\n";

ok( Lingua::EN::Numbers->new(-318712.32)->get_string,
  "Negative Three-Hundred Eighteen Thousand, Seven-Hundred Twelve point Thirty-Two"
);

