package Test::More::Benchmark ;
## This package borrows from Test::Builder::Module and from
## Test::More::Diagnostic.  Not sure which is more appropriate at this
## point.
use 5.6.0 ;
use strict;
use warnings;
use base qw/Test::Builder::Module/ ;

use Benchmark qw/:hireswallclock/ ;
use Data::Dumper ;

use TAP::Parser::YAMLish::Writer ;
## YAML isn't legcal until TAP version 13.
use constant YAML_TAP_VERSION => 13 ;

# $ENV{TAP_VERSION} = 13 ;
our $CLASS = __PACKAGE__ ;  ## not sure what __PACKAGE__ will be when needed.
our @EXPORT = qw(ok_timeit) ;
our $VERSION = '0.1';

sub _should_yaml {
    my $tap_version = $ENV{TAP_VERSION};
    return defined $tap_version && $tap_version >= YAML_TAP_VERSION;
}

    # Regular OK, with timestamps.
sub ok_timeit (&;$) {
    my ( $test, $name ) = @_;
    my $tb = $CLASS->builder;
    if (ref $test ne 'CODE') {
      ## Prototyping is not a panacea; clever folks can bypass it.
      ## sub{ goto &ok_timeit }->( 1, 'Psych!' ) ;
      ## There are probably easier ways, too.
      $tb->note( "You tried to time a test that isn't a subroutine.  That's probably not what you meant" ) ;
      $test = sub { $test } ;
    }
    my $t = timeit( 1, sub { $test = eval {&$test} } ) ;
    warn $@ if $@ ;


    my $ok = $tb->ok( $test, $name );
    ## Is there a more subclassy-way?
    if (_should_yaml()) {
      TAP::Parser::YAMLish::Writer->new->write(
            {
	     timing => timestr($t),
            },
            sub {
	      $tb->_print( '  ' . $_[0]) ;
            }
					      );
    }
    return $ok;
}

1;
__END__

=head1 NAME

Test::More::Benchmark - Building upon C<Test::More::Diagnostic> to add timing data to tests.

=head1 VERSION

This document describes Test::More::Benchmark version 0.1

=head1 SYNOPSIS

    use Test::More;              # DON'T PLAN
    use Test::More::Benchmark;
    plan tests => 1;

    ok_timeit( sub { ... somehting interseting ... }, 'Timed test' ) ;

This package is based upon C<Test::More::Diagnostic>, which some folks might not have installed.  So one might try:

    eval 'use Test::More::Diagnostic';
    diag "Test::More::Diagnostic not available' if $@;

but then it's a little awkward to call C<ok_timeit>.

=head1 EXPORT

C<ok_timeit>

=head1 DESCRIPTION

Building upon C<Test::More::Diagnostic>, we upgrade C<Test::More>'s
output to TAP version 13. See

  http://testanything.org/wiki/index.php/TAP_diagnostic_syntax

for more information about YAML diagnostics.

=head1 INTERFACE 

To add YAML benchmarking to your test output:

    use Test::More;              # DON'T PLAN
    use Test::More::Benchmark;
    plan tests => 1;

It's important that you don't attempt to plan before loading
C<Test::More::Benchmark>. If you do the TAP version line will appear in
the wrong place in the output.

=over

=item C<< ok_timeit >>

A combination of C<Test::Builder>'s "ok" and C<Benchmark>'s "timeit".
The first argument must be a subroutine.  This version executes the
subroutine, then calls "ok" and adds basic YAML output describing the
timing (assuming C<$ENV{TAP_VERSION}> has been set high enough.

=back

=head1 CONFIGURATION AND ENVIRONMENT
  
C<Test::More::Diagnostic> requires no configuration files or environment variables.

=head1 DEPENDENCIES

C<Test::More::Diagnostic>, C<Benchmark>, C<Time::HiRes>.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to C<mcdave@stanford.edu>.

=head1 AUTHOR

David McMath  C<< <mcdave@stanford.edu> >>

=head1 ACKNOWLEDGEMENTS

I ripped most of it off from C<Test::More::Diagnostic> by Andy Armstrong C<< <andy@hexten.net> >>.

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, David McMath C<< <mcdave@stanford.edu> >>. All
rights reserved, to the extent acceptible under Stanford's IP
policies.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
