
require 5;
# Time-stamp: "2005-01-05 16:47:10 AST"
use strict;
use Test;

BEGIN { plan tests => 11 }

use Lingua::EN::Numbers qw(American);

ok 1;
print "# Using Lingua::EN::Numbers v$Lingua::EN::Numbers::VERSION\n";

ok( Lingua::EN::Numbers->new('-318712.32')->get_string,
  "negative three hundred and eighteen thousand seven hundred and twelve point three two"
);

ok( Lingua::EN::Numbers->new('407')->get_string, "four hundred and seven" );

my $x;
$x = Lingua::EN::Numbers->new;
ok defined $x;

$x = Lingua::EN::Numbers->new('456');
ok defined $x;
$x->parse('-1.3');  ok( $x->get_string, "negative one point three" );

$x = Lingua::EN::Numbers->new('15');
ok defined $x;
ok( $x->get_string, "fifteen" );
$x->parse('407');   ok( $x->get_string, "four hundred and seven" );
$x->parse("-3");    ok( $x->get_string, "negative three" );

print "# OK, done.\n";
ok 1;
