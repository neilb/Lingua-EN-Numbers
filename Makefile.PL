# This perl script makes the Makefile

use ExtUtils::MakeMaker;
BEGIN { require 5.004 }

WriteMakefile(
	'NAME'		=>	'Lingua::EN::Numbers',
	'VERSION_FROM'	=>	"Numbers.pm",
	'ABSTRACT'	=>	'Converts numbers into their text equivalents.',
	'AUTHOR'	=>	'Stephen Pandich (pandich@yahoo.com)',
	'PM'		=>	{
		'Numbers.pm'	=>	'${INST_LIBDIR}/Numbers.pm'
	}
);
