#!/usr/bin/perl

use strict;
use warnings;

use Data::Format::Pretty::JSON qw{format_pretty};
use Data::PathSimple qw{get};
use Getopt::Long;
use JSON::XS;
use Pod::Usage;

my (
  $data,
  %options,
);

init();
jsonconf();

sub init {
  # get options {{{

  %options = (
    join => "\n",
  );

  GetOptions(
    'file|f=s'   => \$options{file},
    'join|j=s'   => \$options{join},
    'dump|d'     => \$options{dump},
    'newline|n!' => \$options{newline},
    'visual|v'   => \$options{visual},
  ) or pod2usage(2);

  $options{path} = '/' . join('/', split(/\./, ($ARGV[0] ||'')));

  # }}}

  # read data {{{

  my $fh;

  if ((not $options{file}) or $options{file} eq '--') {
    $fh = \*STDIN;
  }
  else {
    unless (-f $options{file}) {
      die "error: file '$options{file}' does not exist\n";
    }

    open $fh, '<', $options{file}
      or die "error: cannot open file '$options{file}' ($!)\n";
  }

  my ($json) = do { local $/; <$fh> };
  $data      = eval { decode_json($json) };

  if ($@) {
    die "error: invalid JSON was encountered\n";
  }

  # }}}
}

sub jsonconf {
  my $value = ($options{path} eq '/')
    ? $data
    : get($data, $options{path});

  unless ($value) {
    exit 1;
  }

  if ($options{dump}) {
    print format_pretty($value, {color => 0});
    exit;
  }

  my @output;

  if (ref($value) eq 'HASH') {
    foreach my $key (sort keys %{$value}) {
      my ($pre, $post)
        = ($options{visual} and (ref($value->{$key}) eq 'HASH'))  ? ('{', '}')
        : ($options{visual} and (ref($value->{$key}) eq 'ARRAY')) ? ('[', ']')
        : ('', '');

      push @output, "$key$pre$post";
    }
  }
  elsif (ref($value) eq 'ARRAY') {
    foreach my $subvalue (@{$value}) {

      my ($pre, $post)
        = ($options{visual} and (ref($subvalue) eq 'HASH'))  ? ('{', '}')
        : ($options{visual} and (ref($subvalue) eq 'ARRAY')) ? ('[', ']')
        : ('', '');

      push @output, "$subvalue$pre$post";
    }
  }
  else {
    push @output, $value
  }

  print join($options{join}, @output);
  print "\n" unless $options{newline};
}

__END__

=pod

=head1 NAME

jsonexplorer.pl - A simple JSON explorer for the command line (think ls for JSON)

=head1 SYNOPSIS

    jsonexplorer.pl [options] [path]

    $ cat example.json
    {
      "Perl": {
        "CurrentVersion": "5.16.1",
        "URLs": [
          "http://www.perl.org",
          "http://www.cpan.org"
        ]
      },
      "PHP": {
        "CurrentVersion": "5.4.7",
        "URLs": [
          "http://www.php.net",
          "http://pear.php.net"
        ]
      },
      "Python" :  {
        "CurrentVersion": "2.7.3",
        "URLs": [
          "http://www.python.org"
        ]
      },
      "Others": [
        "Go", "Ruby", "Rust"
      ]
    }

    $ jsonexplorer.pl --file example.json
    Others
    PHP
    Perl
    Python

    $ jsonexplorer.pl --file example.json --visual
    Others[]
    PHP{}
    Perl{}
    Python{}

    $ jsonexplorer.pl --file example.json --visual Perl
    CurrentVersion
    URLs[]

    $ jsonexplorer.pl --file example.json --visual Perl.CurrentVersion
    5.16.1

    $ jsonexplorer.pl --file example.json --visual Perl.URLs
    http://www.perl.org
    http://www.cpan.org

    $ jsonexplorer.pl --file example.json --visual Perl.URLs.0
    http://www.perl.org

    $ jsonexplorer.pl --file example.json --dump Others
    [
      "Go",
      "Ruby",
      "Rust"
    ]

    $ jsonexplorer.pl --file example.json --join , Others
    Go,Rust,Ruby

=head1 DESCRIPTION

jsonexplorer.pl is a simple JSON explorer for the command line (think ls for
JSON). Feed it some JSON, navigate within the data, then tell it what the
output should look like. See the SYNOPSIS for examples.

=head1 OPTIONS

=over

=item *

path

If specified, gives the location to navigate to within the JSON. The path is a
'.' separated string of either keys for object values or integers for array
values.

=item *

-d, --dump

Pretty dump the current level.

=item *

-f, --file <filename>

Specifies the JSON file to read. If not specified or '--' is given, read from
standard in.

=item *

-j, --join <string>

Specifies the string to join values at the current level on. Default is a
newline.

=item *

-n, --newline

If specified, a newline won't be added to the end of output.

=item *

-v, --visual

Add visual cues to values that are arrays or objects.

=back

=head1 INSTALLATION

To install from cpan:

    cpan jsonexplorer.pl

To install from source:

    perl Makefile.PL
    make install

Once installed, jsonexplorer.pl should be in your path.

=head1 SUPPORT

Please report any bugs or feature requests at:

  https://github.com/alfie/jsonexplorer.pl/issues

Watch the repository and keep up with the latest changes:

  https://github.com/alfie/jsonexplorer.pl/subscription

Feel free to fork the repository and submit pull requests :)

=head1 DEPENDENCIES

=over

=item *

Data::Format::Pretty::JSON

=item *

Data::PathSimple

=item *

Getopt::Long

=item *

JSON::XS

=item *

Pod::Usage

=back

=head1 SEE ALSO

  http://jsonexplorer.pl

=head1 AUTHOR

Alfie John L<mailto:alfiej@opera.com>

=head1 WARRANTY

IT COMES WITHOUT WARRANTY OF ANY KIND.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Alfie John

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see L<http://www.gnu.org/licenses/>.

=cut
