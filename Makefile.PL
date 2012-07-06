use 5.006;
use strict;
use warnings;

use inc::Module::Install;

# Define metadata
name           'Test-More-Benchmark' ;
all_from       'lib/Test/More/Benchmark.pm';

# Specific dependencies
requires       'Benchmark'  => 0;
requires       'Test::More::Diagnostic' => 0 ;

  # test_requires  'Test::More'  => '0.42';
  # recommends     'Text::CSV_XS'=> '0.50';
  # no_index       'directory'   => 'demos';
  # install_script 'myscript';

WriteAll;
