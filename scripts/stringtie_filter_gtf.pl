#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use IO::File;
use Data::Dumper;

my $expression_metric = '';
my $result_dirs = '';
my $input_gtf_file = '';
my $filtered_gtf_file = '';
my $exp_cutoff = '';
my $min_sample_count = '';

GetOptions('expression_metric=s'=>\$expression_metric, #Choice of expression value type
           'result_dirs=s'=>\$result_dirs, #Dir with expression value GTF files
           'input_gtf_file=s'=>\$input_gtf_file, #Transcript assembly GTF to be filtered 
           'filtered_gtf_file=s'=>\$filtered_gtf_file, #Filtered version of the assembly GTF
	   'exp_cutoff=f'=>\$exp_cutoff, #Value must be greater than this for transcript to expressed
	   'min_sample_count=i'=>\$min_sample_count); #At least this many samples with transcript expressed

unless($expression_metric && $result_dirs && $input_gtf_file && $filtered_gtf_file && defined($exp_cutoff) && defined($min_sample_count)){
    print "\n\nRequired parameters missing\n\n";
    print "Usage:\n\n";
    print "cd \$RNA_HOME/expression/stringtie/ref_guided_merged\n";
    print "./stringtie_filter_gtf.pl --expression_metric=FPKM --result_dirs='HBR_Rep1,HBR_Rep2,HBR_Rep3,UHR_Rep1,UHR_Rep2,UHR_Rep3' --input_gtf_file='/home/ubuntu/workspace/rnaseq/expression/stringtie/ref_guided/stringtie_merged.gtf' --filtered_gtf_file='/home/ubuntu/workspace/rnaseq/expression/stringtie/ref_guided/stringtie_merged.filtered.gtf' --exp_cutoff=0 --min_sample_count=1\n\n";
    exit();
}

#Check for valid coverage metric to be summarized
chomp($expression_metric);
die "\n\nUnexpected expression metric: $expression_metric (allowed options are: TPM, FPKM, coverage)\n\n" unless ($expression_metric =~ /^tpm$|^fpkm$|^coverage$/i);

#Parse and check input result dirs
my %samples;
my $s = 0;
my @sample_list;
my @result_dirs = split(",", $result_dirs);
foreach my $result_dir (@result_dirs){
    die "\n\nCould not find specified result dir: $result_dir\n\n" unless (-e $result_dir && -d $result_dir);
    $s++;
    my $sample_name = $result_dir;
    if ($result_dir =~ /\/(\w+)$/){
        $sample_name = $1;
    }elsif($result_dir =~ /\/(\w+)\/$/){
        $sample_name = $1;
    }
    push(@sample_list, $sample_name);
    $samples{$s}{name} = $sample_name;
    $samples{$s}{dir} = $result_dir;
}
my $sample_count = keys @sample_list;
my $sample_list_s = join("\t", @sample_list);
print "\n\nProcessing data for the following $sample_count samples:\n@sample_list";

#Parse transcript expression values
my %trans_data;
foreach my $s (sort {$a <=> $b} keys %samples){
    my $result_dir = $samples{$s}{dir};
    my $trans_exp = &get_trans_data('-expression_metric'=>$expression_metric, '-dir'=>$result_dir);
    $trans_data{$s} = $trans_exp;
}

#Determine the transcripts that meet the minimum expression criteria. 
#Count the number of qualifying samples for each
my %tids1;
foreach my $s (sort {$a <=> $b} keys %samples){
    my $data = $trans_data{$s};
    foreach my $tid (keys %{$data}){
        if ($data->{$tid}->{exp} > $exp_cutoff){
            $tids1{$tid}++;
	}
    }
}
my %tids2;
foreach my $tid (keys %tids1){
    if ($tids1{$tid} >= $min_sample_count){
        $tids2{$tid} = 1;
    }
}
my $tcount = keys %tids2;
print "\n\nGathered $tcount unique transcripts meet the min expression (>$exp_cutoff $expression_metric) and sample (>= $min_sample_count) criteria";

#Use the list of passing transcript IDs to produce a filtered version of the input GTF
my $fh1 = IO::File->new($input_gtf_file, 'r') || die "\n\nCould not open file: $input_gtf_file\n\n";
my $fh2 = IO::File->new($filtered_gtf_file, 'w') || die "\n\nCould not open file: $filtered_gtf_file\n\n";
while (my $line = $fh1->getline){
    chomp($line);
    if ($line =~ /^\#/){
        print $fh2 "$line\n";
        next;
    }
    my @entry = split("\t", $line);
    next if $entry[2] eq 'gene';
    my $trans_id;
    if($entry[8] =~ /gene_id\s+\"(ERCC\S+)\"\;/){
        $trans_id = $1;
    }elsif ($entry[8] =~ /transcript_id\s+\"(\S+)\"\;/){
        $trans_id = $1;
    }else{
        die "\n\nCould not find transcript id in line: $line\n\n";
    }
    print $fh2 "$line\n" if ($tids2{$trans_id});
}
$fh1->close;
$fh2->close;

print "\n\n";
exit;

sub get_trans_data{
    my %args = @_;
    my $expression_metric = $args{'-expression_metric'};
    my $dir = $args{'-dir'};
    my %exp;
    my $trans_file = $dir . "/transcripts.gtf";
    die "\n\nCould not find transcript abundance file: $trans_file\n\n" unless(-e $trans_file);
    $expression_metric = 'cov' if ($expression_metric =~ /^coverage$/i);

    my $fh = IO::File->new($trans_file, 'r');
    while (my $line = $fh->getline) {
        chomp($line);
        next if ($line =~ /^\#/);
        my @entry = split("\t", $line);
        next unless ($entry[2] eq 'transcript');
        my $trans_id;
        my $exp;
        if($entry[8] =~ /gene_id\s+\"(ERCC\S+)\"\;/){
            $trans_id = $1;
        }elsif ($entry[8] =~ /transcript_id\s+\"(\S+)\"\;/){
            $trans_id = $1;
        }else{
            die "\n\nCould not find transcript id in line: $line\n\n";
        }
        if ($entry[8] =~ /$expression_metric\s+\"(\S+)\"\;/i){
            $exp = $1;
        }else{
            die "\n\nCould not find expression value ($expression_metric) in line: $line\n\n";
        }
        $exp{$trans_id}{exp} = $exp;
    }
    $fh->close;
    return(\%exp);
}

