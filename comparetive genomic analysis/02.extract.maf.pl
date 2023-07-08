#!/usr/bin/perl -w
use strict;
use feature qw/say/;
use List::MoreUtils qw(firstidx);
use Data::Dumper ;

my $usage=<<USAGE;
#pipeline for extracting block from FILE.maf base on species bumber.
        perl $0 [input.maf] [output] [species_number]
#species_number is a number of species of groups,which you want.
#Example:
        perl $0 input.maf output num1 REF
USAGE
die $usage if(!@ARGV);
open IN,'<',$ARGV[0];
open OUT,'>',$ARGV[1];
my $num=$ARGV[2];
my $tag=0;

$/="\n\n"; 

while(<IN>){
        chomp;
	$_=~s/^a .*/a/;
	$_=~s/\n\s+//g;
	my $n=0;
	my @b = split /\n/,$_;
	foreach (@b){
	        if ($_=~/^#/){
        	        print OUT "$_\n";
                        delete $b[$n];
		}
		$n++;
        }
	my @aa = grep {defined $_} @b;
	my $tag=$aa[0];
	shift @aa;
	my $ref_index = firstidx { $_=~/$ARGV[3]/ } @aa;
	splice( @aa, 0, 0, splice( @aa, $ref_index, 1 ) );
	my $count=@aa;
	next if ($count < $num);
	print OUT "$tag\n";
	for(my $i=0; $i<=$#aa; $i++){
		my @aaa=split /\s+/,$aa[$i];
		$aaa[1]=~s/_sp\.\././;
		my $seq=uc ($aaa[-1]);
		$aaa[-1] = $seq;
		print OUT join (" ",@aaa)."\n";
	}
	print OUT "\n";
}
close IN;
close OUT;
