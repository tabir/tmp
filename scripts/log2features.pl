#!/usr/bin/perl 
#################################################################################
# Converts trc file to csv of features where value is the number of occurences
# of each func-line during 1 sec
#
# Usage: log2features.pl --log <log file> 
#   optional:
#      --start <start date-time> --end <end date-time>
#      --filter_in <filter-in-reg-exp> --filter_out <filter-out-exp>
#      --feature_table_in <input-feaure-list>
#      --feature_table_out <output-feaure-list> 
#      --even 
#
#################################################################################

use strict;
use warnings;

use Getopt::Long;
my $log   = "";
my $filter_in = "";
my $filter_out = "";
my $start = "";
my $end = "";
my $feature_table_out = "";
my $feature_table_in = "";

my $help;
my $even;

GetOptions (
    "log=s"                => \$log,     
    "start=s"              => \$start,     
    "end=s"                => \$end,     
    "filter_in=s"          => \$filter_in,     
    "filter_out=s"         => \$filter_out, 
    "feature_table_in=s"   => \$feature_table_in,
    "feature_table_out=s"  => \$feature_table_out,
    "even"                 => \$even, 
    "help"                 => \$help)   
  or die("Error in command line arguments\n");

if ($help) {
    print "Usage: log2features.pl --log <log file> 
    optional:
      --start <start date-time> --end <end date-time>
      --filter_in <filter-in-reg-exp> --filter_out <filter-out-exp>
      --feature_table_in <input-feaure-list>
      --feature_table_out <output-feaure-list> \n";
    exit;
}

my %dates;
#my %features;
my %tbl;

my $IN;
open($IN, "<$log") or die "Can't open $log";

#--- read feature list and fill %features table 
my %features;
my $FTIN;
if ($feature_table_in) {
    open($FTIN, "<$feature_table_in") or die "Can't open $feature_table_in";

    foreach my $line (<$FTIN>) {
	if ($line =~ /(\S+)/) {
	    $features{$1} = 1;
	}
    }
}

#--- open output file to dump feature list
my $FTOUT;
if ($feature_table_out) {
    open($FTOUT, ">$feature_table_out") or die "Can't open $feature_table_out";
}


#--- process trace file

foreach my $line (<$IN>) {
  

    if ($line =~ /^(\S+ \S+)\.\d+ 0x\S+\:(\S+\:\d+)\: /) {
	
	my $date = $1;
	my $feature = $2;

	# convert data to 2-sec (even) mode
	if ($even) {
	    $date =~ /(\d\d\/\d\d \d\d:\d\d:\d)(\d)$/;
	    my $base = $1;
	    my $d = $2;
	    my $m = $d % 2;
	    if ($m == 1) {
		my $n = $d - 1;
		$date = "$base$n";
		print "$date $base   $d  $m $n\n";
	    }
	}
    

	if ($filter_out && ($feature =~ /$filter_out/i)) {
	    next;
	}

	if ($filter_in && ($feature !~ /$filter_in/i)) {
	    next;
	}

	if (($start) && ($date lt $start)) {
	    next;
	}

	if (($end) && ($date gt $end)) {
	    next;
	}

	# skip non relvant features (%features table was already created)
	if (($feature_table_in) && !$features{$feature}) {
	    next;
	}

	$dates{$date} = 1;
	$features{$feature} += 1;
	$tbl{$date,$feature} += 1;

    }
 
}


if ($feature_table_out) {
    foreach my $f (keys %features) {
	#print $FTOUT "$features{$f} $f\n"
	print $FTOUT "$f\n"
    }
    print "Wrote feature-list to $feature_table_out\n";
    exit 0; 
}


#--- header

print "date,";
foreach my $f (keys %features) {
    print "$f,"
}
print "\n";

#--- data

foreach my $d (sort keys %dates) {

    print "$d,";

    foreach my $f (keys %features) {

	my $val = $tbl{$d,$f};
	if (! $val) {
	    $val = 0;
	}

	print "$val,"

    }

    print "\n";

}







