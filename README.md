# NAME

jsonexplorer.pl - A simple JSON explorer for the command line

# SYNOPSIS

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

# DESCRIPTION

jsonexplorer.pl is a simple JSON explorer for the command line (think ls for
JSON). Feed it some JSON, navigate within the data, then tell it what the
output should look like. See the SYNOPSIS for examples.

# OPTIONS

* path

If specified, gives the location to navigate to within the JSON. The path is a
'.' separated string of either keys for object values or integers for array
values.

* -d, --dump

Pretty dump the current level.

* -f, --file <filename>

Specifies the JSON file to read. If not specified or '--' is given, read from
standard in.

* -j, --join <string>

Specifies the string to join values at the current level on. Default is a
newline.

* -n, --newline

If specified, a newline won't be added to the end of output.

* -v, --visual

Add visual cues to values that are arrays or objects.

# INSTALLATION

To install from cpan:

    cpan jsonexplorer.pl

To install from source:

    perl Makefile.PL
    make install

Once installed, jsonexplorer.pl should be in your path.

# SUPPORT

Please report any bugs or feature requests at:

&nbsp;&nbsp;&nbsp;&nbsp;[https://github.com/alfie/jsonexplorer.pl/issues](https://github.com/alfie/jsonexplorer.pl/issues)

Watch the repository and keep up with the latest changes:

&nbsp;&nbsp;&nbsp;&nbsp;[https://github.com/alfie/jsonexplorer.pl/subscription](https://github.com/alfie/jsonexplorer.pl/subscription)

Feel free to fork the repository and submit pull requests :)

# DEPENDENCIES

* Data::Format::Pretty::JSON

* Data::PathSimple

* Getopt::Long

* JSON::XS

* Pod::Usage

# SEE ALSO

&nbsp;&nbsp;&nbsp;&nbsp;[http://jsonexplorer.pl](http://jsonexplorer.pl)

# AUTHOR

[Alfie John](https://github.com/alfie) [alfiej@opera.com](mailto:alfiej@opera.com)

# WARRANTY

IT COMES WITHOUT WARRANTY OF ANY KIND.

# COPYRIGHT AND LICENSE

Copyright (C) 2013 by Alfie John

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see [http://www.gnu.org/licenses/](http://www.gnu.org/licenses/).
