#!perl -T

use Test::More;

BEGIN {
    use_ok( 'Test::More::Benchmark' ) || print "Bail out!\n";
}
plan tests => 1 ;

diag( "Testing Test::More::Benchmark $Test::More::Benchmark::VERSION, Perl $], $^X" );
