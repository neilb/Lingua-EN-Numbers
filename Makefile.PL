# This -*-perl-*- script writes the Makefile for installing this distribution.
#
# See "perldoc perlmodinstall" or "perldoc ExtUtils::MakeMaker" for
# info on how to control how the installation goes.
#
#                                       Time-stamp: "2005-01-01 16:45:20 AST"

require 5.004;
use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	=> 'Lingua::EN::Numbers',
    'VERSION_FROM' => 'lib/Lingua/EN/Numbers.pm', # finds $VERSION
    'dist'        => { COMPRESS => 'gzip -6f', SUFFIX => 'gz', },
);
