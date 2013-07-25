use 5.014002;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME           => 'jsonexplorer.pl',
  VERSION        => '1.0.0',
  EXE_FILES      => [
  'bin/jsonexplorer.pl',
  ],
  PREREQ_FATAL   => undef,
  PREREQ_PM      => {
  'Data::Format::Pretty::JSON',
  'Data::PathSimple',
  'Getopt::Long',
  'JSON::XS',
  'Pod::Usage',
  },
  (
    $] >= 5.005
      ? (
          ABSTRACT_FROM => 'bin/jsonexplorer.pl',
          AUTHOR        => 'Alfie John <alfiej@opera.com>'
        )
      : ()
  ),
);
