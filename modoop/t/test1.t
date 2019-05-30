#!/usr/bin/env perl

use strict;
use warnings;
use FindBin; use lib "$FindBin::Bin/../lib";
use Test::More;
use Local::User;

use_ok 'Local::User';

my $src = Local::User::Local::Meowse->new(
    name => 'vanya',
);
print $src->{name}."\n";

