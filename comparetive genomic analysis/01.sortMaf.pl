#!/usr/bin/perl -w

=head1 Description

This script is used to sort the input MAF format multiple alignments (e.g., maf format file generated from Cactus) by sequence names and their strands.

=head1 Command-line Option

  --ref <str>       reference of input multiple alignments
  --input <str>     input MAF format file

  --help            output help information to screen

=head1 Usage Exmples

  01.sortMaf.pl -i cactus.maf -r zeberafish > zebrafish.bed.maf.sort

=cut

use strict;
use Getopt::Long;
use Data::Dumper;

my ($Input,$Ref,$Help);
GetOptions(
        "ref:s"=>\$Ref,
        "input:s"=>\$Input,
        "help"=>\$Help
);

die `pod2text $0` if ($Help);

open IN,$Input;

$/="\n\n";

my $reftag=0;

while(<IN>){

    chomp;
    $_=~s/^a .*/a/;	
    $_=~s/\n\s+//g;
    my @b = split /\n/,$_;
    my @aa;
	my $i=0;
    foreach (@b){
	if ($_=~/^#/ || $_=~/^a/){
		print "$_\n";
			delete $b[$i];
	}elsif ($_=~/$Ref/){
		print "$_\n";
			delete $b[$i];
	}
	$i++;
    }
	my @array = grep {defined $_} @b;
	foreach (@array){
		print "$_\n";
	}
    print "\n";
}
close IN;
