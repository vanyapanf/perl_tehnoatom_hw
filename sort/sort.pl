#!/usr/bin/env perl

use 5.016;
use warnings;
use Getopt::Long; # для обработки аргументов
use Scalar::Util qw(looks_like_number);
#use Scalar::Util qw(reftype);
my $k;
my $n;
my $r;
my $u;
my $m;
my $b1;
my $k1;
my $fl = 0;
my $fl1 = 0;
my $fl3 = 0;
my $fl5 = 0;
my $fl6 = 0;
my (@str) = <STDIN>;
#my %hash;
my @str1;
my @kol_pr;
for (@str) { chop($_);}
GetOptions (
	'k=i' => \$k,
	'n' => \$n,
	'r' => \$r,
	'u' => \$u,
	'M' => \$m,
	'b' => \$b1
);
if ($b1) {
	for my $i (0..$#str) {
		$kol_pr[$i] = 0;
		while (index($str[$i], " ") == 0) {
			++$kol_pr[$i];
			$str[$i] = substr ($str[$i], 1, length($str[$i]) - 1);
		}
	}
	$fl6 = 1;
}
my @arr = @str;
if ($k) {
	my $stlb ;
	my $indx = 0;
	--$k;
	for (my $i = 0; $i < @arr; $i++){
		my @str_arr = split /\s+/, $arr[$i];
		$str1[$i] = \@str_arr;
		$stlb = (@{$str1[$i]} - 1 ) unless defined $stlb;
		if ($stlb > (@{$str1[$i]} - 1)) { $stlb = @{$str1[$i]}-1;} 
	}
	if (($stlb < $k) or ($k < 0)) { 
		die "K has wrong value";
	}
	#for my $i (0..$#str1) {#@str1-1
		#$arr[$i] = @{$str1[$i]}[$k];
	#}
	@arr = map {$_->[$k]} @str1;
	my %uniq ;
	my @uniq1 = grep {!$uniq{$_}++}	@arr;
	@arr = @uniq1;
	$fl = 1;
}
if ($n) {
	my @arr1;
	my @arr2;
	#my $ind1 = 0;
	#my $ind2 = 0;
	for (@arr) {
		if (!looks_like_number($_)) { 
			#$arr1[$ind1] = $_;
			#$ind1++;
			push @arr1, $_;
		}
		else { 
			#$arr2[$ind2] = $_;
			#$ind2++;
			push @arr2, $_;
		}
	}
	my @num = sort {$a <=> $b} @arr2;
	@arr = (@arr1,@num);
	$fl1 = 1;
}
if ($m) {
	my @month = ('jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec');
	my @kol_mon;
	my @not_mon;
	my $indx = 0;
	for my $i (0..11) { $kol_mon[$i] = 0;}	
	for my $i (0..$#arr) {
		my $fl2 = 0;
		for my $j (0..11) {
			if ($arr[$i] eq $month[$j]) { 
				++$kol_mon[$j];
				$fl2 = 1;
			}
		}
		if ($fl2 == 0) {
				$not_mon[$indx] = $arr[$i];
				$indx++;
		}		
	}
	@arr = @not_mon;
	for my $i (0..11) {
		if ($kol_mon[$i] != 0) {
			for (1..$kol_mon[$i]) {
				@arr=(@arr,$month[$i]);
			}
		}
	}
	$fl5 = 1;
}
if (($fl1 == 0) and ($fl5 == 0)){
	#my @sort_arr = sort @arr;
	@arr = sort @arr;
}
if ($r) {
	my @rev = reverse @arr;
	@arr = @rev;
}
if ($u) {
	my %uniq;
	#my @uniq1 = grep {!$uniq{$_}++}	@arr;
	@arr = grep {!$uniq{$_}++} @arr;
	$fl3 = 1;
}

if ($fl == 0) {
	#for (my $i = 0; $i < @arr; $i++) {
		#say $arr[$i];
	#}
	for (0..$#arr) {
		if ($fl6) { print " " for (1..$kol_pr[$_]); }
		say $arr[$_];
	}
}
else {
	if ($fl3) {
		for my $i (0..$#arr) {
			my $fl4 = 1;
			for my $j (0..$#str1) {
				if (($arr[$i] eq @{$str1[$j]}[$k]) and ($fl4)) {
					if ($fl6) { print " " for (1..$kol_pr[$i]);}
					say $str[$j];
					$fl4 = 0;
				}
			}
		}
	}
	else {
		for my $i (0..$#arr) {
			for my $j (0..$#str1) {
				if ($arr[$i] eq @{$str1[$j]}[$k]) {
					if ($fl6) { print " " for (1..$kol_pr[$i]); }
					say $str[$j];
				}
			}
		}
	}
}
exit;
















