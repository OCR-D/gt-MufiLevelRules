NAME
    README for unicruft - UTF-8 approximation library and tools

DESCRIPTION
    The `unicruft' package contains both a C library and command-line
    utilities for robust approximation of UTF-8 input by ASCII, Latin-1,
    and/or the subet of Latin-1 used in contemporary German orthography
    (henceforth referred to as "Latin-1.DE").

    The basic transliteration heuristics in uxTableAscii.c were
    auto-generated from those used by the Text::Unidecode(3pm) Perl module
    by Sean M. Burke.

INSTALLATION
  Requirements
   C Libraries
    Nothing special required, although use of the GNU GNU C library is
    highly recommended.

   Development Tools
    C compiler
        tested version(s): gcc v4.3.3 / linux

    GNU flex (development only)
        tested version(s): 2.5.33

        Only needed if you plan on making changes to the lexer sources.

    GNU autoconf (SVN only)
        tested version(s): 2.61

        Required for building from SVN sources.

    GNU automake (SVN only)
        tested version(s): 1.9.6

        Required for building from SVN sources.

    Perl (perl bindings only)
        tested version(s): 5.10.0

  Building from SVN
    To build this package from SVN sources, you must first run the shell
    command:

     bash$ sh ./autoreconf.sh

    from the distribution root directory BEFORE running ./configure.
    Building from SVN sources requires additional development tools to
    present on the build system. Then, follow the instructions in "Building
    from Source".

    Included in the SVN repository are perl bindings for the unicruft
    library in the distribution subdirectory ./perl. See the file README.txt
    in that directory for installation details.

  Building from Source
    To build and install the entire package, issue the following commands to
    the shell:

     bash$ cd unicruft-0.01      # (or wherever you unpacked this distribution)
     bash$ sh ./configure        # configure the package
     bash$ make                  # build the package
     bash$ make install          # install the package on your system

    More details on the top-level installation process can be found in the
    file INSTALL in the distribution root directory.

USAGE
     unicruft --help

    Will print a brief help message. See the unicruft(1) manpage for more
    details.

SEE ALSO
    Text::Unidecode(3pm), recode(1), iconv(1), ...

AUTHOR
    Bryan Jurish <jurish@bbaw.de>

URL:
    https://kaskade.dwds.de/~moocow/software/unicruft/


