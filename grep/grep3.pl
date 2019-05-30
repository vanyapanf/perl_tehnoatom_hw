#!/usr/bin/env perl

use 5.016;

use warnings;
use Getopt::Long qw(:config no_ignore_case bundling);
use Encode;
binmode STDIN, ':encoding(UTF-8)';
binmode STDOUT, ':encoding(UTF-8)';
my $A=0;
my $B=0;
my $C=0;
my $c1;
my $i;
my $v;
my $F;
my $n;
GetOptions (
	'A=i' => \$A,
	'B=i' => \$B,
	'C=i' => \$C,
	'c' => \$c1,
	'i' => \$i,
	'v' => \$v,
	'F' => \$F,
	'n' => \$n
);
my $s = $ARGV[0];
$s = decode_utf8($s);
my @arr;
my @print;
my $str = "";
my $left = 0;
my $right = 0;
if ($B < $C) {
	$left = $C;
}
else { 
	$left = $B;
}
if ($A < $C) {
	$right = $C;
}
else { 
	$right = $A;
}
my $accept = 0;
my $ind = 0;
my $fl = 0;
while (<STDIN>) {
		if (@arr == $left + $right + 1) {
			if ($fl == 0) {
				my $left1 = $left-1;
				if ($left1>=0) {
					for (0..$left1) {
						$str = $arr[$_];
						++$ind;
						if (Fvi($str)) {
							++$accept;
							pr(\@arr,\@print,$ind,0,$_+$right) if (!$c1);
						}
					}
				}
				$fl = 1;
			}
			$str = $arr[$left];
			++$ind;
			if (Fvi($str)) {
				++$accept;
				pr(\@arr,\@print,$ind,0,$#arr) if (!$c1);
			}
			push @arr,$_;
			push @print,"0";
			shift @arr;
			shift @print;
		}
		elsif (@arr < $left + $right +1) {
			push @arr,$_;
			push @print,"0";
		}	
}
if ($fl) {
		for ($left .. $#arr) {
			$str = $arr[$_];
			++$ind;
			if (Fvi($str)) {
				++$accept;
				pr(\@arr,\@print,$ind,$_-$left,$#arr) if (!$c1);
			}
		}
}
else {
		for (0 .. $#arr) {
			$str = $arr[$_];
			++$ind;
			if (Fvi($str)) {
				++$accept;
				if (!$c1) {
					my $ind1 = $_ - $left;
					my $ind2 = $_ + $right;
					if ($ind1<0) { $ind1 = 0;}
					if ($ind2>$#arr) { $ind2 = $#arr;}
					pr(\@arr,\@print,$ind,$ind1,$ind2) if (!$c1);					
				}
			}
		}

}
if ($c1) { say $accept;}				 		
sub Fvi {
	my $str = shift;
	if (!$F and !$v and !$i) {
		if ($str =~ $s) {
			return 1;
		}
	}
	if ($F and !$v and !$i ) {
		if ($str =~ /\Q$s\E/) {
			return 1;
		}
	}
	if (!$F and $v and !$i) {
		if (!($str =~ $s)) {
			return 1;
		}
	}
	if ( $F and $v and !$i) {
		if (!($str =~ /\Q$s\E/)) {
			return 1;
		}
	}
	if (!$F and !$v and $i) {
		if ($str =~ /$s/i){
			return 1;
		}
	}
	if ($F and !$v and $i) {
		if ($str =~ /\Q$s\E/i) {
			return 1;
		}
	}
	if (!$F and $v and $i) {
		if (!($str =~ /$s/i)) {
			return 1;
		}
	}
	if ($F and $v and $i) {
		if (!($str =~ /\Q$s\E/i)) {
			return 1;
		}
	}	
	return 0;
}
sub pr {
	my $ref_arr = shift;
	my $ref_print = shift;
	my $indx = shift;
	my $ind1 = shift;
	my $ind2 = shift;
	$indx = $indx - $left;
	$indx = 1 if ($indx<=0);
	for ($ind1 .. $ind2) {  
		if (( @{$ref_print}[$_] eq "0") and !$n ){
			print @{$ref_arr}[$_]; 
			@{$ref_print} = "1";
		}
		if (( @{$ref_print}[$_] eq "0") and $n ){
			print ($indx,':',@{$ref_arr}[$_]); 
			@{$ref_print}[$_] = "1";
		}
		++$indx;
	}
	return 1;
}









