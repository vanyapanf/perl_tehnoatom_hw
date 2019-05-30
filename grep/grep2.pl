#!/usr/bin/env perl

use 5.016;

#use encoding 'utf8';
#use utf8;
use warnings;
use Getopt::Long qw(:config no_ignore_case bundling);
#use open qw (:std :utf8);
use Encode;
binmode STDIN, ':encoding(UTF-8)';
binmode STDOUT, ':encoding(UTF-8)';
my $A;
my $B;
my $C;
my $c1;
my $i;
my $v;
my $F;
my $n;
my $fl = 0;
my $fl1 = 0;
my $fl2 = 0;
my $fl3 = 0;
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
if ($F) {
	$fl1 = 1;
}
if ($i) {
	$fl = 1;
}
if ($v) {
	$fl2 = 1;
}
if ($c1) {
	my $accept = 0;
	while (<STDIN>) {
		$str = $_;
		$fl3 = fl1fl2();
		if ($fl3) {++$accept;}
	}
	say $accept;
}
if ($A) {
	my $ind = 0;
	while (<STDIN>) {
		if (@arr == $A + 1) {
			$str = $arr[0];
			$fl3 = fl1fl2();
			++$ind;
			if ($fl3) {
				for (0..$#arr) { 
					if (( $print[$_] eq "0") and !$n){
						print $arr[$_]; $print[$_] = "1";
					}
					if (( $print[$_] eq "0") and $n){
						print ($ind+$_,':',$arr[$_]); $print[$_] = "1";
					}
				}
			}
			push @arr,$_;
			push @print,0;
			shift @arr;
			shift @print;
		}
		elsif (@arr < $A+1) {
			push @arr,$_;
			push @print,0;
		}	
	}
	while (@arr) {
		$str = $arr[0];
		$fl3 = fl1fl2();
		++$ind;
		if ($fl3) {
			for (0..$#arr) { 
					if (( $print[$_] eq "0") and !$n){
						print $arr[$_]; $print[$_] = "1";
					}
					if (( $print[$_] eq "0") and $n){
						print ($ind+$_,':',$arr[$_]); $print[$_] = "1";
					}
			}
		}
		shift @arr;
		shift @print;
        }
}
if ($B) {
	my $ind = 0;
	my $fl5 = 0;
	while (<STDIN>) {
		if ($fl5) {
			$str = $arr[$#arr];
		}
		else {
			$str = $_;
		} 
		$fl3 = fl1fl2();
		++$ind;
		if ($fl3 and $fl5) {
			for (0..$#arr) { 
					if (( $print[$_] eq "0") and !$n){
						print $arr[$_]; $print[$_] = "1";
					}
					if (( $print[$_] eq "0") and $n){
						print ($ind-@arr+$_,':',$arr[$_]); $print[$_] = "1";
					}
			}
		}
		if (@arr == $B + 1) {
			push @arr,$_;
			push @print,"0";
			shift @arr;
			shift @print;
		}
		elsif (@arr < $B+1) {
			push @arr,$_;
			push @print,"0";
			$fl5 = 1;
		}	
	}
	$str = $arr[$#arr];
	$fl3 = fl1fl2();
	++$ind;
	if ($fl3 ) {
		for (0..$#arr) { 
				if (( $print[$_] eq "0") and !$n){
					print $arr[$_]; $print[$_] = "1";
				}
				if (( $print[$_] eq "0") and $n){
					print ($ind-@arr+$_,':',$arr[$_]); $print[$_] = "1";
				}
		}
	}
}
if ($C) {
	my $ind = 0;
	my $fl4 = 0;
	while (<STDIN>) {
		if (@arr == 2*$C + 1) {
			if ($fl4 == 0) {
				for (0..$C-1) {
					$str = $arr[$_];
					$fl3 = fl1fl2();
					++$ind;
					if ($fl3) {
						for (0 .. $_+$C) { 
							if (( $print[$_] eq "0") and !$n){
								print $arr[$_]; $print[$_] = "1";
							}
							if (( $print[$_] eq "0") and $n){
								print ($ind+$_,':',$arr[$_]); $print[$_] = "1";
							}
						}
					}
				}
				$fl4 = 1;
			}
			$str = $arr[$C];
			$fl3 = fl1fl2();
			++$ind;
			if ($fl3) {
				for (0 .. $#arr){ 
					if (( $print[$_] eq "0") and !$n){
						print $arr[$_]; $print[$_] = "1";
					}
					if (( $print[$_] eq "0") and $n){
						print ($ind-$C+$_,':',$arr[$_]); $print[$_] = "1";
					}
				}
			}
			push @arr,$_;
			push @print,"0";
			shift @arr;
			shift @print;
		}
		elsif (@arr < 2*$C+1) {
			push @arr,$_;
			push @print,"0";
		}	
	}
	if ($fl4) {
		for ($C .. $#arr) {
			$str = $arr[$_];
			$fl3 = fl1fl2();
			if ($fl3) {
				for ($_-$C .. $#arr){ 
					++$ind;
					if (( $print[$_] eq "0") and !$n){
						print $arr[$_]; $print[$_] = "1";
					}
					if (( $print[$_] eq "0") and $n){
						print ($ind,':',$arr[$_]); $print[$_] = "1";
					}
				}
			}
		}
	}
	else {
		for (0 .. $#arr) {
			$str = $arr[$_];
			$fl3 = fl1fl2();
			if ($fl3) {
				my $ind1 = $_ - $C;
				my $ind2 = $_ + $C;
				if ($ind1<0) { $ind1 = 0;}
				if ($ind2>$#arr) { $ind2 = $#arr;}
   				for ($ind1 .. $ind2) {  
					if (( $print[$_] eq "0") and !$n){
						print $arr[$_]; $print[$_] = "1";
					}
					if (( $print[$_] eq "0") and $n){
						print ($_+1,':',$arr[$_]); $print[$_] = "1";
					}
				}
			}
		}				
	}
}			 		
else {
	my $ind = 0;
	while (<STDIN>) {
		$str = $_;
		$fl3 = fl1fl2();
		++$ind;
		if ($fl3) { 
			if (!$n){
				print $_; 
			}
			if ($n){
				print $ind,':',$_;
			}
		}
	}
}
sub fl1fl2 {
	if (($fl1 == 0) and ($fl2 == 0) and ($fl == 0)) {
		if ($str =~ $s) {
			return 1;
		}
	}
	if (($fl1 == 1) and ($fl2 == 0)and ($fl == 0) ) {
		if ($str =~ /\Q$s\E/) {
			return 1;
		}
	}
	if (($fl1 == 0) and ($fl2 == 1)and ($fl == 0) ) {
		if (!($str =~ $s)) {
			return 1;
		}
	}
	if (($fl1 == 1) and ($fl2 == 1) and ($fl == 0)) {
		if (!($str =~ /\Q$s\E/)) {
			return 1;
		}
	}
	if (($fl1 == 0) and ($fl2 == 0) and ($fl == 1)) {
		if ($str =~ /$s/i){
			return 1;
		}
	}
	if (($fl1 == 1) and ($fl2 == 0) and ($fl == 1)) {
		if ($str =~ /\Q$s\E/i) {
			return 1;
		}
	}
	if (($fl1 == 0) and ($fl2 == 1) and ($fl == 1)) {
		if (!($str =~ /$s/i)) {
			return 1;
		}
	}
	if (($fl1 == 1) and ($fl2 == 1) and ($fl == 1)) {
		if (!($str =~ /\Q$s\E/i)) {
			return 1;
		}
	}	
	return 0;
}










