#!/usr/bin/env perl
package 
use strict;
use warnings;
use 5.016;
use lib './lib';
use Local::Meowse;

Local::Meowse::has 'name' => ( is => 'rw');
my $class = Local::Meowse::new
