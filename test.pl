BEGIN {
	$| = 1;
	$loaded = 0;
	print "Running tests 1..2\n";
	$child = 0;
}

END {
	print "not ok 1\n" unless $loaded;
	kill 9, $child if ($child);
}

use Lingua::EN::Numbers;
$loaded = 1;
print "ok 1\n";


$l = new Lingua::EN::Numbers(-318712.32);
$text1 = "Negative Three-Hundred Eighteen Thousand, Seven-Hundred Twelve point Thirty-Two";
$text2 = $l->get_string();


if ($text1 eq $text2) {
	print "ok 1\n";
} else {
	print "not ok 1\n";
}
