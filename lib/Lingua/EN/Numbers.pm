
require 5.004;  # Time-stamp: "2005-01-05 17:12:51 AST"
package Lingua::EN::Numbers;

require Exporter;
@ISA = qw(Exporter);

use strict;
use warnings;
BEGIN { *DEBUG = sub () {0} unless defined &DEBUG } # setup a DEBUG constant
use vars qw(
 @EXPORT @EXPORT_OK $VERSION
 $MODE $TRUE $FALSE
 %D %Card2ord %Mult
 %MADV %MADJ
);
$VERSION = '1.07';
@EXPORT    = ();
@EXPORT_OK = qw( num2en num2en_ordinal num2en_multiadv num2en_multiadj );

#--------------------------------------------------------------------------
# Here begins the old junk, including mock-object stuff:

$TRUE = 1; $FALSE = 0; $MODE = "American";
sub import { 
  @_ = grep { $_ ne 'American' and $_ ne 'British' } @_;
  goto &Exporter::import;
}

sub new {
  my $class = shift;
  my $obj = bless [undef],  ref($class) || $class;
  $obj->parse($_[0]);
  return $obj;
}

sub parse { $_[0][0] = $_[1]; return 1; }
sub get_string { num2en( $_[0][0] ); }

# End of legacy stuff.
#--------------------------------------------------------------------------

@MADV{1 .. 3} = qw|
  once twice thrice
|;

@MADJ{1 .. 10} = qw|
  single double triple quadruple quintuple
  sextuple septuple octuple nonuple decuple
|;

@D{0 .. 20, 30,40,50,60,70,80,90} = qw|
 zero
 one two three four five six seven eight nine ten
 eleven twelve thirteen fourteen fifteen
 sixteen seventeen eighteen nineteen
 twenty thirty forty fifty sixty seventy eighty ninety
|;


@Card2ord{  qw| one   two    three five  eight  nine  twelve  |}
 =          qw| first second third fifth eighth ninth twelfth |;


{
  my $c = 0;
  for ( '', qw<
    thousand million billion trillion quadrillion quintillion sextillion
    septillion octillion nonillion
  > ) {
    $Mult{$c} = $_;
    $c++;
  }
}

#==========================================================================

sub num2en_ordinal {
   #  Cardinals are [one two three...]
   #  Ordinals  are [first second third...]
  
  return undef unless defined $_[0] and length $_[0];
  my($x) = $_[0];
  
  $x = num2en($x);
  return $x unless $x;
  $x =~ s/(\w+)$//s   or return $x . "th";
  my $last = $1;

  $last =
   $Card2ord{$last} || ( $last =~ s/y$/ieth/ && $last ) || ( $last . "th" );

  return "$x$last";
}

#==========================================================================

sub num2en {
  my $x = $_[0];
  return undef unless defined $x and length $x;

  return 'not-a-number'      if $x eq 'NaN';
  return 'positive infinity' if $x =~ m/^\+inf(?:inity)?$/si;
  return 'negative infinity' if $x =~ m/^\-inf(?:inity)?$/si;
  return          'infinity' if $x =~  m/^inf(?:inity)?$/si;

  return $D{$x} if exists $D{$x};  # the most common cases

  # Make sure it's not in scientific notation:
  {  my $e = _e2en($x);  return $e if defined $e; }
  
  my $orig = $x;

  $x =~ s/,//g; # nix any commas

  my $sign;
  $sign = $1 if $x =~ s/^([-+])//s;
  
  my($int, $fract);
  if(    $x =~ m<^\d+$>          ) { $int = $x }
  elsif( $x =~ m<^(\d+)\.(\d+)$> ) { $int = $1; $fract = $2 }
  elsif( $x =~ m<^\.(\d+)$>      ) { $fract = $1 }
  else {
    DEBUG and print "Not a number: \"orig\"\n";
    return undef;
  }
  
  DEBUG and printf " Working on Sign[%s]  Int2en[%s]  Fract[%s]  < \"%s\"\n",
   map defined($_) ? $_ : "nil", $sign, $int, $fract, $orig;
  
  return join ' ', grep defined($_) && length($_),
    _sign2en($sign),
    _int2en($int),
    _fract2en($fract),
  ;
}

#==========================================================================

sub num2en_multiadv {
  return unless defined $_[0] and length $_[0];
  my $x = $_[0];
  my $y = num2en($x);
  return "umpteen times" unless $y; # if we don't know the number, it must be a lot!

  return $MADV{$x} if($MADV{$x});
  return "$y times";
}

sub num2en_multiadj {
  return unless defined $_[0] and length $_[0];
  my $x = $_[0];
  my $y = num2en($x);
  return "many-fold" unless $y; # if we don't know the number, it must be a lot!
  
  return $MADJ{$x}   if($MADJ{$x});
  return "${y}-fold" if($x % 10 == 0);
  return "${y}fold";
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

sub _sign2en {
  return undef unless defined $_[0] and length $_[0];  
  return 'negative' if $_[0] eq '-';
  return 'positive' if $_[0] eq '+';
  return "WHAT_IS_$_[0]";
}

sub _fract2en {    # "1234" => "point one two three four"
  return undef unless defined $_[0] and length $_[0];  
  my $x = $_[0];
  return join ' ', 'point', map $D{$_}, split '', $x;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# The real work:

sub _int2en {
  return undef unless defined $_[0] and length $_[0]
   and $_[0] =~ m/^\d+$/s;

  my($x) = $_[0];

  return $D{$x} if defined $D{$x};  # most common/irreg cases
  
  if( $x =~ m/^(.)(.)$/ ) {
    return  $D{$1 . '0'} . '-' . $D{$2};
     # like    forty        -     two
      # note that neither bit can be zero at this point
     
  } elsif( $x =~ m/^(.)(..)$/ ) {
    my($h, $rest) = ("$D{$1} hundred", $2);
    return $h if $rest eq '00';
    return "$h and " . _int2en(0 + $rest);
  } else {
    return _bigint2en($x);
  }
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

sub _bigint2en {
  return undef unless defined $_[0] and length $_[0]
   and $_[0] =~ m/^\d+$/s;

  my($x) = $_[0];

  my @chunks;  # each:  [ string, exponent ]
  
  {
    my $groupnum = 0;
    my $num;
    while( $x =~ s<(\d{1,3})$><>s ) { # pull at most three digits from the end
      $num = $1 + 0;
      unshift @chunks, [ $num, $groupnum ] if $num;
      ++$groupnum;
    }
    return $D{'0'} unless @chunks;  # rare but possible
  }
  
  my $and;
  
  $and = 'and' if  $chunks[-1][1] == 0  and  $chunks[-1][0] < 100;
   # The special 'and' that shows up in like "one thousand and eight"
   # and "two billion and fifteen", but not "one thousand [*and] five hundred"
   # or "one million, [*and] nine"

  _chunks2en( \@chunks );

  # bugfix: neilb: deals with case where we have at least millions, thousands,
  # but 00N for the last chunk.
  # $chunks[-2] .= " and" if $and and @chunks > 1;
  if ($and and @chunks > 1) {
    $chunks[-2] .= " and $chunks[-1]";
    pop(@chunks);
  }

  return "$chunks[0] $chunks[1]" if @chunks == 2 and !$and;
   # Avoid having a comma if just two units
  return join ", ", @chunks;
}


sub _chunks2en {
  my $chunks = $_[0];
  return unless @$chunks;
  my @out;
  foreach my $c (@$chunks) {
    push @out,   $c = _groupify( _int2en( $c->[0] ),  $c->[1] )  if $c->[0];
  }
  @$chunks = @out;
  return;
}

sub _groupify {
  # turn ("seventeen", 3) => "seventeen billion"
  my($basic, $multnum) = @_;
  return  $basic unless $multnum;  # the first group is unitless
  DEBUG > 2 and print "  Groupifying $basic x $multnum mults\n";
  return "$basic $Mult{$multnum}"  if  $Mult{$multnum};
   # Otherwise it must be huuuuuge, so fake it with scientific notation
  return "$basic " . "times ten to the " . num2en_ordinal($multnum * 3);
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# Because I can never remember this:
#
#  3.1E8
#  ^^^   is called the "mantissa"
#      ^ is called the "exponent"
#         (the implicit "10" is the "base" a/k/a "radix")

sub _e2en {
  my $x = $_[0];

  my($m, $e);
  if( $x =~
    m<
      ^(
        [-+]?  # leading sign
        (?:
          [\d,]+  |  [\d,]*\.\d+  # number
        )
       )
      [eE]
      (-?\d+)   # mantissa, has to be an integer
      $
    >x
  ) {
    ($m, $e) = ($1, $2);
    DEBUG and print "  Scientific notation: [$x] => $m E $e\n";
    $e += 0;
    return num2en($m) . ' times ten to the ' . num2en_ordinal($e);
  } else {
    DEBUG and print "  Okay, $x isn't in exponential notation\n";
    return undef;
  }
}

#==========================================================================
1;

__END__

=head1 NAME

Lingua::EN::Numbers - turn "407" into "four hundred and seven", etc.

=head1 SYNOPSIS

  use Lingua::EN::Numbers qw(num2en num2en_ordinal);

  my $x = 234;
  my $y = 54;
  print "You have ", num2en($x), " things to do today!\n";
  print "You will stop caring after the ", num2en_ordinal($y), ".\n";

prints:

  You have two hundred and thirty-four things to do today!
  You will stop caring after the fifty-fourth.

=head1 DESCRIPTION

Lingua::EN::Numbers provides a function C<num2en> that converts
a number (such as 123) into English text
(such as "one hundred and twenty-three").
It also provides a function C<num2en_ordinal> that converts
a number into the ordinal form in words,
so 54 becomes "fifty-fourth".

If you pass either function something that doesn't look like a number,
they will return C<undef>.

This module can handle integers like "12" or "-3" and real numbers like "53.19".

This module also understands exponential notation -- it turns "4E9" into
"four times ten to the ninth").  And it even turns "INF", "-INF", "NaN"
into "infinity", "negative infinity", and "not a number", respectively.

Any commas in the input numbers are ignored.

=head1 LEGACY INTERFACE

B<Note:> this legacy interface is now deprecated, and will be dropped
in a future release. Please let me (Neil) know if you're using this
interface, and I'll do something to continue supporting you.

For some amount of backward compatibility with the old (before 1.01)
version of this module, the old OO interface is supported, where you can
construct a number object with C<new(I<[optionalvalue]>)>, change its
value with C<parse(I<value>)>, and get its Engish expression with
C<get_string()>.

=head1 SEE ALSO

L<http://neilb.org/reviews/spell-numbers.html> - a review of CPAN modules for converting numbers into English words.

L<Lingua::EN::Nums2Words>,
L<Math::BigInt::Named>,
L<Number::Spell>,
L<Lingua::EN::Numbers::Ordinate>,
L<Lingua::EN::Numbers::Years>,
L<Lingua::EN::Inflect>.

=head1 REPOSITORY

L<https://github.com/neilbowers/Lingua-EN-Numbers>

=head1 COPYRIGHT

Copyright (c) 2005, Sean M. Burke.

Copyright (c) 2011-2013, Neil Bowers, minor changes in 1.02 and later.

This library is free software; you can redistribute it and/or modify
it only under the terms of version 2 of the GNU General Public License
(L<perlgpl>).

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

(But if you have any problems with this library, I ask that you let
me know.)

=head1 AUTHOR

The first release to CPAN, 0.01, was written by Stephen Pandich
in 1999.

Sean M Burke took over maintenance in 2005, and completely rewrote
the module, releasing versions 0.02 and 1.01.

Neil Bowers E<lt>neilb@cpan.orgE<gt> has been maintaining the module
since 2011.

=cut

