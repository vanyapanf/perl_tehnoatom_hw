package Local::User;

use strict;
use warnings;
#use FindBin; 
use lib '../../lib';
use Local::Meowse;

Local::Meowse::has (name => ( is => 'rw' , required => 0));

1;
