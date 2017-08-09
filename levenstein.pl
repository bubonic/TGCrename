#!/usr/bin/perl 
use List::Util qw(min);

sub levenshtein
{
    my ($str1, $str2) = @_;
    my @ar1 = split //, $str1;
    my @ar2 = split //, $str2;

    my @dist;
    $dist[$_][0] = $_ foreach (0 .. @ar1);
    $dist[0][$_] = $_ foreach (0 .. @ar2);

    foreach my $i (1 .. @ar1) {
        foreach my $j (1 .. @ar2) {
            my $cost = $ar1[$i - 1] eq $ar2[$j - 1] ? 0 : 1;
            $dist[$i][$j] = min(
                            $dist[$i - 1][$j] + 1, 
                            $dist[$i][$j - 1] + 1, 
                            $dist[$i - 1][$j - 1] + $cost
                             );
        }
    }

    return $dist[@ar1][@ar2];
}
open(my $fh2, "$ARGV[1]");
chomp(my @strings2=<$fh2>);
my $str1 = $ARGV[0];
my $k=0;
my $min = 100;
my $COURSE = " ";
foreach my $str2 (@strings2) {
        my $lev=levenshtein($str1, $str2);
	if ( $k == 0 ) { 
		$min = $lev;
		$COURSE = $str2;
	}
	if ( $lev < $min ) {
		$min = $lev;
		$COURSE = $str2;
	}
	my $k = $k++;
#        print "$str1 / $str2 : $lev\n";
}

print "$COURSE\n";
