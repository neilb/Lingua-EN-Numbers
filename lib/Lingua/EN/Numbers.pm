
package Lingua::EN::Numbers;
require 5.004;  # Time-stamp: "2005-01-01 17:11:06 AST"

require Exporter;
@ISA = qw(Exporter);

use Carp;
use strict qw(vars);
use vars qw(
 @EXPORT @EXPORT_OK $VERSION
 $MODE
 %INPUT_GROUP_DELIMITER %INPUT_DECIMAL_DELIMITER %OUTPUT_BLOCK_DELIMITER
 %OUTPUT_GROUP_DELIMITER %OUTPUT_NUMBER_DELIMITER
 %OUTPUT_DECIMAL_DELIMITER %NUMBER_NAMES %SIGN_NAMES
 $TRUE $FALSE $SIGN_POSITIVE $SIGN_NEGATIVE
);

BEGIN { *DEBUG = sub () {0} unless defined &DEBUG } # setup a DEBUG constant

BEGIN {
	$VERSION = '0.02';

	# Exporter Stuff
	@EXPORT = qw();
	@EXPORT_OK = qw(American British);

	# Constants
	$TRUE = 1;
	$FALSE = 0;
	$SIGN_POSITIVE = 1;
	$SIGN_NEGATIVE = -1;

	# Default Mode
	$MODE = "American";

	# Delimiters
	%OUTPUT_NUMBER_DELIMITER = (
		'American'	=>	'-',
		'British'	=>	'-'
	);

	%OUTPUT_GROUP_DELIMITER = (
		'American'	=>	' ',
		'British'	=>	' '
	);

	%OUTPUT_BLOCK_DELIMITER = (
		'American'	=>	', ',
		'British'	=>	', '
	);

	%OUTPUT_DECIMAL_DELIMITER = (
		'American'	=>	'point ',
		'British'	=>	'point '
	);


	%INPUT_GROUP_DELIMITER = (
		'American'	=>	',',
		'British'	=>	'.'
	);

	%INPUT_DECIMAL_DELIMITER = (
		'American'	=>	'.',
		'British'	=>	','
	);


	# Low-Level Names
	%SIGN_NAMES = (
		'American'	=>	{
			$SIGN_POSITIVE	=>	'',
			$SIGN_NEGATIVE	=>	'Negative'
		},
		'British'	=>	{
			$SIGN_POSITIVE	=>	'',
			$SIGN_NEGATIVE	=>	'Negative'
		}
	);

	%NUMBER_NAMES = (
		'American'	=>	{
			0	=>	'Zero',
			1	=>	'One',
			2	=>	'Two',
			3	=>	'Three',
			4	=>	'Four',
			5	=>	'Five',
			6	=>	'Six',
			7	=>	'Seven',
			8	=>	'Eight',
			9	=>	'Nine',
			10	=>	'Ten',
			11	=>	'Eleven',
			12	=>	'Twelve',
			13	=>	'Thirteen',
			14	=>	'Fourteen',
			15	=>	'Fifteen',
			16	=>	'Sixteen',
			17	=>	'Seventeen',
			18	=>	'Eighteen',
			19	=>	'Nineteen',
			20	=>	'Twenty',
			30	=>	'Thirty',
			40	=>	'Forty',
			50	=>	'Fifty',
			60	=>	'Sixty',
			70	=>	'Seventy',
			80	=>	'Eighty',
			90	=>	'Ninety',
			10**2	=>	'Hundred',
			10**3	=>	'Thousand',
			10**6	=>	'Million',
			10**9	=>	'Billion',
			10**12	=>	'Trillion',
			10**15	=>	'Quadrillion',
			10**18	=>	'Quintillion',
			10**21	=>	'Sextillion',
			10**24	=>	'Septillion',
			10**27	=>	'Octillion',
			10**30	=>	'Nonillian',
			10**33	=>	'Decillion',
			10**36	=>	'Undecillion',
			10**39	=>	'Duodecillion',
			10**42	=>	'Tredecillion',
			10**45	=>	'Quattuordecillion',
			10**48	=>	'Quindecillion',
			10**51	=>	'Sexdecillion',
			10**54	=>	'Septendecillion',
			10**57	=>	'Octodecillion',
			10**60	=>	'Novemdecillion',
			10**63	=>	'Vigintillion'
		},
		'British'	=>	{
			0	=>	'Zero',
			1	=>	'One',
			2	=>	'Two',
			3	=>	'Three',
			4	=>	'Four',
			5	=>	'Five',
			6	=>	'Six',
			7	=>	'Seven',
			8	=>	'Eight',
			9	=>	'Nine',
			10	=>	'Ten',
			11	=>	'Eleven',
			12	=>	'Twelve',
			13	=>	'Thirteen',
			14	=>	'Fourteen',
			15	=>	'Fifteen',
			16	=>	'Sixteen',
			17	=>	'Seventeen',
			18	=>	'Eighteen',
			19	=>	'Nineteen',
			20	=>	'Twenty',
			30	=>	'Thirty',
			40	=>	'Fourty',
			50	=>	'Fifty',
			60	=>	'Sixty',
			70	=>	'Seventy',
			80	=>	'Eighty',
			90	=>	'Ninety',
			10**2	=>	'Hundred',
			10**3	=>	'Thousand',
			10**6	=>	'Million',
			10**9	=>	'Milliard',
			10**12	=>	'Billion',
			10**15	=>	'Billiard',
			10**18	=>	'Trillion',
			10**21	=>	'Trilliard',
			10**24	=>	'Quadrillion',
			10**27	=>	'Quadrilliard',
			10**30	=>	'Quintillion',
			10**33	=>	'Quintilliard',
			10**36	=>	'Sextillion',
			10**39	=>	'Sextilliard',
			10**42	=>	'Septillion',
			10**45	=>	'Septilliard',
			10**48	=>	'Octillion',
			10**51	=>	'Octilliard',
			10**54	=>	'Nonillian',
			10**57	=>	'Nonilliard',
			10**60	=>	'Decillion',
			10**63	=>	'Decilliard'
		}
	);
}

#################################################################
# Exporter Routines
#################################################################
sub import {
	my ($module, $tag) = @_;
	if ($tag and ($tag eq "American") || ($tag eq "British")) {
		$MODE = $tag;
	}
	else {
		croak "Error: $module does not support tag: '$tag'.\n"
			if ($tag);
	}
}

#################################################################
# Math Routines
#################################################################
sub pow10Block {
	my ($number) = @_;
	if ($number) {
		return (int(pow10($number) / 3) * 3);
	} else {
		return 0;
	}
}

sub pow10 {
	my ($number) = @_;
	return int(log10($number));
}

sub log10 {
	my ($number) = @_;
	return logn(10, $number);
}

sub logn {
	my ($base, $number) = @_;
	return log($number) / log($base);
}

#################################################################
# Numeric String Parsing Routines
#################################################################
sub string_to_number {
	my ($numberString) = @_;

	# Strip out delimiters
	$numberString =~ s/\Q$INPUT_GROUP_DELIMITER{$MODE}\E//g;

        DEBUG > 3 and print "   Parsing numberstring [$numberString]\n";

	my $sign = $SIGN_POSITIVE;
	if ($numberString =~ s/^-//) {
	  $sign = $SIGN_NEGATIVE if $numberString =~ m/[1-9]/;
	    # (but drop the sign on -0, -0.000, -.00000, etc)
	}
	
	if(    $numberString =~ m/^0+$/s   ) { $numberString = '0' }
	elsif( $numberString =~
	 m/^0+\Q$INPUT_DECIMAL_DELIMITER{$MODE}\E/s ) { } # allow a predecimal zero
	else {
	  # Otherwise, strip any leading zeroes
	  $numberString =~ s/^0+//g;
        }

	my $number = '';
	my $decimal = '';
	if ($numberString =~ /^(.*)\Q$INPUT_DECIMAL_DELIMITER{$MODE}\E(.+$)/) {
		($number, $decimal) = ($1, $2);
	} else {
		$number = $numberString;
	}

	if ($number =~ /\D/) {
		carp "Error: bad number format: '$number'.\n";
		return ();
	}
	if ($decimal && ($decimal =~ /\D/)) {
		carp "Error: bad number format: '.$decimal'.\n";
		return ();
	}

	return ($number, $decimal, $sign);
}

sub parse_number {
	my ($number) = @_;

	if (! $number) {
		return {'0'=>$NUMBER_NAMES{$MODE}{0}};
	}

	my %names;
	my $powerOfTen = pow10Block($number);
	while ($powerOfTen > 0) {
		my $factor = int($number / 10**$powerOfTen);
		my $component = $factor * 10**$powerOfTen;
		my $magnitude = $NUMBER_NAMES{$MODE}{10**$powerOfTen};
		my $factorName = &parse_number_low($factor);

		$names{$component}{'factor'} = $factorName;
		$names{$component}{'magnitude'} = $magnitude;
		
		$number -= $component;
		$powerOfTen = pow10Block($number);
	}

	if ($number) {
		$names{'1'}{'factor'} = &parse_number_low($number);
		$names{'1'}{'magnitude'} = '';
	}

	return \%names;
}

sub parse_number_low {
	my ($number) = @_;
	my @names;

	if ($number >= 100) {
		my $hundreds = int($number / 10**2);
		push @names, [ $NUMBER_NAMES{$MODE}{$hundreds}, $NUMBER_NAMES{$MODE}{10**2} ];
		$number -= $hundreds * 10**2;
	}

	if ($number >= 20) {
		my $tens = int($number / 10**1) * 10**1;
		my $ones = $number - $tens;

		if ($ones) {
			push @names, [ $NUMBER_NAMES{$MODE}{$tens} , $NUMBER_NAMES{$MODE}{$ones} ];
		} else {
			push @names, [ $NUMBER_NAMES{$MODE}{$tens} ];
		}
	} else {
		push @names, [ $NUMBER_NAMES{$MODE}{$number} ];
	}

	return \@names;
}


#################################################################
# Class Methods
#################################################################
sub new {
	my ($class, @initializer) = @_;

	if (! defined $class || ! $class) {
		return ();
	}

	my $self = {};
	bless $self, $class;

	if (@initializer) {
		$self->parse(@initializer);
	}

	return $self;
}

sub do_get_string {
	my ($self, $block) = @_;

	if (! defined $self || ! $self) {
		return '';
	}

	if (! defined $block || ! $block) {
		return '';
	}

	my @blockStrings;
	my $number = $self->{'string_data'}{$block};
	
	DEBUG > 4 and print "     Components: ", join(" ", map("$_",
	  sort {$b <=> $a } keys %$number)), "\n";
	
	foreach my $component(sort {$b <=> $a } keys %$number) {
		my $magnitude = $$number{$component}{'magnitude'} || '';
		my $factor = $$number{$component}{'factor'};
                next unless $factor and @$factor;
		my @strings = map join($OUTPUT_NUMBER_DELIMITER{$MODE}, @$_), @$factor;
		
		DEBUG > 5 and print "     Strings: [@strings]  Magnitude[$magnitude]  Factor[@{$$factor[0]}]\n";
		
		my $string = join($OUTPUT_GROUP_DELIMITER{$MODE}, @strings) . ' ' . $magnitude;
		push @blockStrings, $string;
	}
	
	DEBUG > 4 and print "     Blockstrings[", map("<$_>", @blockStrings), "]\n";

	my $blockString = join($OUTPUT_BLOCK_DELIMITER{$MODE}, @blockStrings)
	 || $NUMBER_NAMES{$MODE}{0};
	$blockString .= ' ';
	
	DEBUG > 4 and print "     Blockstring[$blockString]\n";
	
	return $blockString;
}


sub parse {
	my ($self, $numberString) = @_;

        DEBUG > 2 and print "  Got number string to parse: [",
         defined($numberString) ? $numberString : 'undef', "]\n";

	if (! defined $self || ! $self) {
		return $FALSE;
	}

	my ($number, $decimal, $sign) = &string_to_number($numberString);

	$self->{'numeric_data'}{'number'} = $number;
	$self->{'numeric_data'}{'decimal'} = $decimal;
	$self->{'numeric_data'}{'sign'} = $sign;

        DEBUG > 2 and print "  Got num[$number] dec[$decimal] sign[$sign]\n";

	if (defined $number) {
	  $self->{'string_data'}{'number'} = &parse_number($number);
	  $self->{'string_data'}{'sign'} = $SIGN_NAMES{$MODE}{$sign};
	}
	
	if (defined $decimal && $decimal) {
		$self->{'string_data'}{'decimal'} = &parse_number($decimal);
	}
	
	return $TRUE;
}

sub get_string {
	my ($self) = @_;

	if (! defined $self || ! $self) {
		return '';
	}

	my @strings;
	push @strings, $self->do_get_string('number');
	if ($self->{'string_data'}{'decimal'}) {
		push @strings, $self->do_get_string('decimal');
	}
	
	shift @strings if @strings > 1 and $strings[0] eq $NUMBER_NAMES{$MODE}{0};
	 # don't need the zero on "zero point five"

	my $string = join($OUTPUT_DECIMAL_DELIMITER{$MODE}, @strings);
	if ($self->{'string_data'}{'sign'}) {
		$string = $self->{'string_data'}{'sign'} . " $string";
	}

	$string =~ s/\s+$//;
	$string =~ s/\s+/ /g;
	return $string;
}

1;

__END__

=head1 NAME

Lingua::EN::Numbers - Converts numeric values into their English string equivalents.

=head1 SYNOPSIS

	## EXAMPLE 1

	use Lingua::EN::Numbers qw(American);

	$n = new Lingua::EN::Numbers(313721.23);
	if (defined $n) {
		$s = $n->get_string;
		print "$s\n";
	}


	## EXAMPLE 2

	use Lingua::EN::Numbers;

	$n = new Lingua::EN::Numbers;
	$n->parse(-1281);
	print "N = " . $n->get_string . "\n";


  prints:
        N = Negative One Thousand, Two-Hundred Eighty-One


=head1 REQUIRES

Perl 5, Exporter, Carp


=head1 DESCRIPTION

Lingua::EN::Numbers converts arbitrary numbers into human-oriented
English text. Limited support is included for parsing standardly
formatted numbers (i.e. '3,213.23'). But no attempt has been made to
handle any complex formats. Support for multiple variants of English
are supported. Currently only "American" formatting is supported.

To use the class, an instance is generated. The instance is then loaded
with a number. This can occur either during construction of the instance
or later, via a call to the B<parse> method. The number is then analyzed
and parsed into the english text equivalent.

The instance, now initialized, can be converted into a string, via the
B<get_string> method. This method takes the parsed data and converts
it from a data structure into a formatted string. Elements of the string's
formatting can be tweaked between calls to the B<get_string> function.
While such changes are unlikely, this has been done simply to provide
maximum flexability.


=head1 METHODS

=head2 Creation

=over 4

=item new Lingua::EN::Numbers $numberString

Creates, optionally initializes, and returns a new instance.

=back

=head2 Initialization

=over 4

=item $number->parse $numberString

Parses a number and (re)initializes an instance.

=back

=head2 Output

=over 4

=item $number->get_string

Returns a formatted string based on the most recent B<parse>.

=back


=head1 CLASS VARIABLES

=over 4

=item $Lingua::EN::Numbers::VERSION

The version of this class.

=item $Lingua::EN::Numbers::MODE

The current locale mode. Currently only B<American> is supported.

=item %Lingua::EN::Numbers::INPUT_GROUP_DELIMITER

The delimiter which seperates number groups.
B<Example:> "1B<,>321B<,>323" uses the comma 'B<,>' as the group delimiter.

=item %Lingua::EN::Numbers::INPUT_DECIMAL_DELIMITER

The delimiter which seperates the main number from its decimal part.
B<Example:> "132B<.>2" uses the period 'B<.>' as the decimal delimiter.

=item %Lingua::EN::Numbers::OUTPUT_BLOCK_DELIMITER

A character used at output time to convert the number into a string.
B<Example:> One Thousand, Two-Hundred and Twenty-Two point Four.
Uses the space character ' ' as the block delimiter.

=item %Lingua::EN::Numbers::OUTPUT_GROUP_DELIMITER

A character used at output time to convert the number into a string.
B<Example:> One ThousandB<,> Two-Hundred and Twenty-Two point Four.
Uses the comma 'B<,>' character as the group delimiter.

=item %Lingua::EN::Numbers::OUTPUT_NUMBER_DELIMITER

A character used at output time to convert the number into a string.
B<Example:> One Thousand, TwoB<->Hundred and TwentyB<->Two point Four.
Uses the dash 'B<->' character as the number delimiter.

=item %Lingua::EN::Numbers::OUTPUT_DECIMAL_DELIMITER

A character used at output time to convert the number into a string.
B<Example:> One Thousand, Two-Hundred and Twenty-Two B<point> Four.
Uses the 'point' string as the decimal delimiter.

=item %Lingua::EN::Numbers::NUMBER_NAMES

A list of names for numbers.

=item %Lingua::EN::Numbers::SIGN_NAMES

A list of names for positive and negative signs.

=item $Lingua::EN::Numbers::SIGN_POSITIVE

A constant indicating the the current number is positive.

=item $Lingua::EN::Numbers::SIGN_NEGATIVE

A constant indicating the the current number is negative.

=back


=head1 DIAGNOSTICS

=over 4

=item Error: Lingua::EN::Numbers does not support tag: '$tag'.

(F) The module has been invoked with an invalid locale.

=item Error: bad number format: '$number'.

(F) The number specified is not in a valid numeric format.

=item Error: bad number format: '.$number'.

(F) The decimal portion of number specified is not in a valid numeric format.

=back

=head1 COPYRIGHT

Copyright (c) 2005, Sean M. Burke

Copyright (c) 1999, Stephen Pandich.

This library is free software; you can redistribute it and/or modify
it only under the terms of version 2 of the GNU General Public License
(L<perlgpl>).

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

(But if you have any problems with this library, I ask that you let
me know.)


=head1 AUTHOR

Original author: Stephen Pandich, pandich@yahoo.com

Current maintainer: Sean M. Burke, sburke@cpan.org

=cut

