#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Test::More::Benchmark' ) || print "Bail out!\n";
}

diag( "Testing Test::More::Benchmark $Test::More::Benchmark::VERSION, Perl $], $^X" );
