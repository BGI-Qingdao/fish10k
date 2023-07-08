#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $usage=<<USAGE;
      usage: $0 <species.list> <maf>
USAGE
die $usage if (!@ARGV);

open IN,"$ARGV[0]" or die $!;
my @species;
while (<IN>){
	chomp;
	push @species,$_;
}
close IN;

open IN,"$ARGV[1]" or die $!;
$/="a\n"; <IN>; 

my %total;
my $total_len;
while (<IN>){
	chomp;
	$_=~s/\n\s+$//;
	my @a=split /\s+/,$_;
	my $len;
	my %seq;
	for (my $i=1;$i<=$#a;$i+=7){
		my $sp=$1 if ($a[$i]=~/(.*?)\.([^.]+)(.*)/);
		$seq{$sp}=$a[$i+5];
#		print Dumper ($sp);
	}
	my $len=$a[3];
	$total_len+=$len;
	foreach (@species){
		if (! exists $seq{$_}){
			$seq{$_}="-" x $len;
		}
		$total{$_}.=$seq{$_};
	}	
	
}
close IN;

open OUT,">combined_substr.phy" or die $!;
print OUT "\t316\t$total_len\n";
foreach (keys %total){
	print OUT "$_\t$total{$_}\n";
}
close OUT;
