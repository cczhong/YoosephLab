#!/usr/bin/perl -w
use strict;

my $bfile = shift;	# the blastp result file generated by re-map the GRASP recruited reads
my $families = shift;	# pfam IDs separated by comma, i.e. PF00001,PF00010

my @pfam_IDs = split /\,+/, $families;
my %pfam_hash;
foreach(@pfam_IDs)	{
	$pfam_hash{$_} = 1;
}

open my $BIN, "<$bfile" or die "Cannot open file: $!\n";
my $num_total = 0;
my $num_false = 0;
my $num_new = 0;
my $num_correct = 0;
while(<$BIN>)	{
	chomp;
	if(/(\d+) hits found/)	{
		if($1 > 0)	{
			my $best_record = <$BIN>;
			my @decom = split /\s+/, $best_record;
			my @decom_1 = split /\./, $decom[1];
			#print "$decom_1[0]\n";
			if(!(exists $pfam_hash{$decom_1[0]}))	{
				++ $num_false;
			}	else	{
				++ $num_correct;
			}
		}	else	{
			++ $num_new;	
		}
		++ $num_total;
	}
}
close $BIN;
print "$num_correct	$num_false	$num_new	$num_total\n";

