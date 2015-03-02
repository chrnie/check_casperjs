#!/usr/bin/perl -w
# COPYRIGHT:
#
# This software is Copyright (c) 2015 NETWAYS GmbH, Christoph Niemann
#                                <support@netways.de>
#
# (Except where explicitly superseded by other copyright notices)
#
#
# LICENSE:
#
# This work is made available to you under the terms of Version 2 of
# the GNU General Public License. A copy of that license should have
# been provided with this software, but in any event can be snarfed
# from http://www.fsf.org.
#
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 or visit their web page on the internet at
# http://www.fsf.org.
#
#
# CONTRIBUTION SUBMISSION POLICY:
#
# (The following paragraph is not intended to limit the rights granted
# to you to modify and distribute this software under the terms of
# the GNU General Public License and is only of importance to you if
# you choose to contribute your changes and enhancements to the
# community by submitting them to NETWAYS GmbH.)
#
# By intentionally submitting any modifications, corrections or
# derivatives to this work, or any other work intended for use with
# this Software, to NETWAYS GmbH, you confirm that
# you are the copyright holder for those contributions and you grant
# NETWAYS GmbH a nonexclusive, worldwide, irrevocable,
# royalty-free, perpetual, license to use, copy, create derivative
# works based on those contributions, and sublicense and distribute
# those contributions and any derivatives thereof.
#
# Nagios and the Nagios logo are registered trademarks of Ethan Galstad.
=head1 NAME

check_casperjs.pl - calls casperjs usecases and returns results to icinga/shinken/nagios ...

=head1 SYNOPSIS

check_casperjs.pl
-v
-h
-V
-e
-f

Requirements:
This plugin needs casperjs and phantomjs

Usage: 
check_casperjs.pl -w WARNING -c CRITICAL -t tests/simple_example.js
check_casperjs.pl -w WARNING -c CRITICAL --url='http://my.example.com' --screenshots -o OPTION1=bla OPTION2=blub OPTIONn=bli

=head1 OPTIONS

=over

=item -c|--critical

critical threshold in ms for overall duration

=item -w|--warning

warning threshold in ms for overall duration

=item -o|--casperjs-options

add extra options for casperjs

=item -t|--test-case

test case for casperjs

=item -h|--help

display this help and exit

=item     --usage

display a short usage instruction

=item -p|--proxy

need proxy?

=item -u|--url

for variable urls

=item -s|--screenshots

capture screenshots on each step.

=item -v|--verbose

be verbose

=item -V|--version

output version information and exit

=cut

use strict;
use Getopt::Long qw(:config no_ignore_case bundling);
use Pod::Usage;
use File::Basename;
use Data::Dumper;
use XML::Simple;

use FindBin qw($Bin);

# declaration of variables
my (
  $opt_critical, $opt_warning, $opt_help,     $opt_usage, 
  $opt_version,  $opt_verbose, $opt_testcase, $opt_proxy,
  $opt_tmpdir,   $opt_url, $opt_screenshots,  %opt_casperopts,  
  %states, %state_names,   $out_state, $out_text, $perfdata
);

my $progname = basename($0);
my $basedir = $Bin;
my $version = '0.6';

GetOptions (
  "c|critical=i"          => \$opt_critical,
  "w|warning=i"           => \$opt_warning,
  "h|help"                => \$opt_help,
  "usage"                 => \$opt_usage,
  "V|version"             => \$opt_version,
  "v|verbose"             => \$opt_verbose,
  "p|proxy=s"             => \$opt_proxy,
  "t|test-case=s"         => \$opt_testcase,
  "o|casperjs-options=s"  => \%opt_casperopts,
  "d|tmpdir=s"            => \$opt_tmpdir,
  "u|url=s"               => \$opt_url,
  "s|screenshots"         => \$opt_screenshots,
) || die "Try `$progname --help' for more information.\n";

# Exit states
%states = (
  OK       => 0, WARNING  => 1,
  CRITICAL => 2, UNKNOWN  => 3
);
# Exit state names
%state_names = (
  0 => 'OK',       1 => 'WARNING',
  2 => 'CRITICAL', 3 => 'UNKNOWN'
);


# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
# help and version page and sample config...
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

sub print_usage() {
  print "Usage: $progname -w WARNING -c CRITICAL --url='http://my.example.com' --screenshots -o OPTION1=bla OPTION2=blub OPTIONn=bli\n";
  print "       $progname --help\n";
  print "       $progname --version\n";
}

sub print_version() {
        print "$progname $version\n";
}

if ($opt_help) {
  pod2usage(1);
  exit $states{'UNKNOWN'};
}
if ($opt_usage) {
  print_usage();
  exit $states{'UNKNOWN'};
}
if ($opt_version) {
  print_version();
  exit $states{'UNKNOWN'};
}
unless ($opt_critical && $opt_warning) {
  print_usage();
  exit $states{'UNKNOWN'};
}



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
# prepare options for casperjs
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

# add xml-out tmpfile
# default:
$opt_tmpdir = '/tmp/check_casperjs' if not defined $opt_tmpdir;
unless (-d $opt_tmpdir ) {
  mkdir $opt_tmpdir
}
my $tmpfile = "$opt_tmpdir/casper_" . time() . "_" . int(rand(99999)) . ".tmp";
while ( -e $opt_tmpdir ) {
  $opt_tmpdir .= "1";
}
print "tmpfile: $tmpfile\n" if defined $opt_verbose;

# rebuild options
my $casper_opts;
for (keys %opt_casperopts) {
  #print $_ . " - " . $opt_casperopts{$_} . "\n";
  $casper_opts .= "--$_=\'$opt_casperopts{$_}\' "
}

# add default options
$casper_opts  = '' if not defined $casper_opts;
$casper_opts .= ' --verbose' if defined $opt_verbose;
$casper_opts .= " --proxy-type=http --proxy=\'$opt_proxy\'" if defined $opt_proxy;
$casper_opts .= " --xunit=$tmpfile --no-colors";

# add options for --url
$casper_opts .= " $basedir/lib/lib_url.js --url=$opt_url" if defined $opt_url;

# add options for --screenshots

#*************************************************************************************************
#  MAIN
#*************************************************************************************************

# convert ms to s
$opt_warning  /= 1000;
$opt_critical /= 1000;

#call casperjs
print "CALL: casperjs test --pre=lib/lib_default.js $casper_opts $opt_testcase\n" if defined $opt_verbose;
my @casper_in = `casperjs test --pre=$basedir/lib/lib_default.js $casper_opts $basedir/$opt_testcase`;

print @casper_in if defined $opt_verbose;

# Read tmpfile
my $ref = XMLin($tmpfile, KeyAttr => ['testcase']);

# Delete tmpfile
unlink $tmpfile;

# Verbose DataDump
print Dumper($ref) if defined $opt_verbose;
$out_state=0;
# Catch Failures and Errors
if ($$ref{'testsuite'}{'failures'} > 0) {
  $out_state = 2;
}
if ($$ref{'testsuite'}{'errors'} > 0) {
  $out_state = 3;
  print "$state_names{$out_state} - An error occured in casperjs\n";
  exit $out_state;
}

# collect data from xmlFile

if ($$ref{'testsuite'}{'tests'} == 1) {
  if (defined $$ref{'testsuite'}{'testcase'}{'time'}) {
    $perfdata .= "\'$$ref{'testsuite'}{'testcase'}{'name'}\'=$$ref{'testsuite'}{'testcase'}{'time'}s;$opt_warning;$opt_critical;0;$opt_critical ";
    if (defined $$ref{'testsuite'}{'testcase'}{'failure'}) {
      $out_text .= "FAIL $$ref{'testsuite'}{'testcase'}{'name'} in $$ref{'testsuite'}{'testcase'}{'time'} s\n";
      $out_state=2;
    } else {
      $out_text .= "PASS $$ref{'testsuite'}{'testcase'}{'name'} in $$ref{'testsuite'}{'testcase'}{'time'} s\n";
    }
  }
} else {
  foreach my $caseRef( @{$$ref{'testsuite'}{'testcase'}} ) {
    if (defined $$caseRef{'time'}) {
      $perfdata .= "\'$$caseRef{'name'}\'=$$caseRef{'time'}s;$opt_warning;$opt_critical;0;$opt_critical ";
      if (defined $$caseRef{'failure'}) {
        $out_text .= "FAIL $$caseRef{'name'} in $$caseRef{'time'} s\n";
        $out_state=2;
      } else {
        $out_text .= "PASS $$caseRef{'name'} in $$caseRef{'time'} s\n";
      }
    }
  }
}
$perfdata .= "\'total\'=$$ref{'time'}s;$opt_warning;$opt_critical;0;$opt_critical ";

# Calculate output state
if ( $$ref{'time'} > $opt_warning && $out_state != 2 ) {
  $out_state = 1;
  $out_text = "Service timed out\n$out_text";
} elsif ( $$ref{'time'} > $opt_critical) {
  $out_state = 2;
  $out_text = "Service timed out\n$out_text";
}

# Print and Exit
print "$state_names{$out_state} - $out_text|$perfdata\n";

exit $out_state;
