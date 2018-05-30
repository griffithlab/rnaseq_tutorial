#!/usr/bin/perl

use strict;
use warnings;

use IO::File;

my $ercc_file = 'ERCC_Controls_Analysis.txt';
my $counts_file = 'gene_read_counts_table_all_final.tsv';
my $ercc_counts_file = 'ercc_read_counts.tsv';

my $ercc_fh = IO::File->new($ercc_file,'r');
unless ($ercc_fh) { die('Failed to find file: '. $ercc_file) }

my %ercc_data;
while (my $ercc_line = $ercc_fh->getline) {
    chomp($ercc_line);
    if ($ercc_line =~ /^Re/) { next; }
    #my ($resort,$id,$subgroup,$mix1,$mix2,$fold_change,$log2)
    my @ercc_entry = split("\t",$ercc_line);
    $ercc_data{$ercc_entry[1]} = \@ercc_entry;
}

my @labels = qw/UHR_Rep1 UHR_Rep2 UHR_Rep3 HBR_Rep1 HBR_Rep2 HBR_Rep3/;

my $counts_fh = IO::File->new($counts_file,'r');
unless ($counts_fh) { die('Failed to find file: '. $counts_file); }

my $ercc_counts_fh = IO::File->new($ercc_counts_file,'w');
unless ($ercc_counts_fh) { die('Failed to open file: '. $ercc_counts_file); }

my %count_data;
print $ercc_counts_fh "ID\tSubgroup\tLabel\tMix\tConcentration\tCount\n";
while (my $counts_line = $counts_fh->getline) {
    chomp($counts_line);
    my @count_entry = split('\t',$counts_line);
    if ($ercc_data{$count_entry[0]}) {
        my $id = $count_entry[0];
        my $subgroup = $ercc_data{$id}->[2];
        for (my $i = 0; $i < scalar(@labels); $i++) {
            my $count = $count_entry[$i+1];
            my $label = $labels[$i];
            my $conc;
            my $mix;
            if ($label =~ /UHR/) {
                $mix = 1;
                $conc = $ercc_data{$id}->[3];
            } else {
                $mix = 2;
                $conc = $ercc_data{$id}->[4];
            }
            print $ercc_counts_fh $id ."\t". $subgroup ."\t". $label ."\t". $mix ."\t". $conc ."\t". $count ."\n";
        }
    }
}


exit;
