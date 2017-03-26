#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use IO::File;
use Data::Dumper;

my $expression_metric = '';
my $result_dirs = '';
my $transcript_matrix_file = '';
my $gene_matrix_file = '';

GetOptions('expression_metric=s'=>\$expression_metric, 
           'result_dirs=s'=>\$result_dirs, 
           'transcript_matrix_file=s'=>\$transcript_matrix_file,
           'gene_matrix_file=s'=>\$gene_matrix_file);

unless($expression_metric && $result_dirs && $transcript_matrix_file && $gene_matrix_file){
    print "\n\nRequired parameters missing\n\n";
    print "Usage:  ./stringtie_expression_matrix.pl --expression_metric=TPM  --result_dirs='HBR_Rep1,HBR_Rep2,HBR_Rep3,UHR_Rep1,UHR_Rep2,UHR_Rep3' --transcript_matrix_file=transcript_tpms_all_samples.tsv --gene_matrix_file=gene_tpms_all_samples.tsv\n\n";
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

#Parse gene expression values
my %gene_data;
foreach my $s (sort {$a <=> $b} keys %samples){
    my $result_dir = $samples{$s}{dir};
    my $gene_exp = &get_gene_data('-expression_metric'=>$expression_metric, '-dir'=>$result_dir);
    $gene_data{$s} = $gene_exp;
}

#Get a list of unique transcript IDs found across all data files
my %tids;
foreach my $s (sort {$a <=> $b} keys %samples){
    my $data = $trans_data{$s};
    foreach my $tid (keys %{$data}){
        $tids{$tid}++;
    }
}
my $tcount = keys %tids;
print "\n\nGathered $expression_metric expression values for $tcount unique transcripts";

#Get a list of unique gene IDs found across all data files
my %gids;
foreach my $s (sort {$a <=> $b} keys %samples){
    my $data = $gene_data{$s};
    foreach my $gid (keys %{$data}){
        $gids{$gid}++;
    }
}
my $gcount = keys %gids;
print "\n\nGathered $expression_metric expression values for $gcount unique genes";

#Write out the transcript file
my $to_fh = IO::File->new($transcript_matrix_file, 'w');
unless ($to_fh) { die('Failed to open file: '. $transcript_matrix_file); }
print $to_fh "Transcript_ID\t$sample_list_s\n";
foreach my $tid (sort keys %tids){
    my @line;
    push(@line, $tid);
    foreach my $s (sort {$a <=> $b} keys %samples){
        my $data = $trans_data{$s};
        my $exp = "na";
        if (defined($data->{$tid})){
            $exp = $data->{$tid}->{exp};
        }
        push(@line, $exp);
    }
    my $line = join("\t", @line);
    print $to_fh "$line\n";
}
$to_fh->close;
print "\n\nPrinted transcript $expression_metric expression matrix to $transcript_matrix_file";

#Write out the gene file
my $go_fh = IO::File->new($gene_matrix_file, 'w');
unless ($go_fh) { die('Failed to open file: '. $gene_matrix_file); }
print $go_fh "Gene_ID\t$sample_list_s\n";
foreach my $gid (sort keys %gids){
    my @line;
    push(@line, $gid);
    foreach my $s (sort {$a <=> $b} keys %samples){
        my $data = $gene_data{$s};
        my $exp = "na";
        if (defined($data->{$gid})){
            $exp = $data->{$gid}->{exp};
        }
        push(@line, $exp);
    }
    my $line = join("\t", @line);
    print $go_fh "$line\n";
}
$go_fh->close;
print "\n\nPrinted gene $expression_metric expression matrix to $gene_matrix_file";

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
        }elsif ($entry[8] =~ /transcript_id\s+\"(\w+)\"\;/){
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

sub get_gene_data{
    my %args = @_;
    my $expression_metric = $args{'-expression_metric'};
    my $dir = $args{'-dir'};
    my %exp;
    my $gene_file = $dir . "/gene_abundances.tsv";
    die "\n\nCould not find gene abundance file: $gene_file\n\n" unless(-e $gene_file);

    my $fh = IO::File->new($gene_file, 'r');
    my $l = 0;
    my $c = 0;
    my $metric_col;
    while (my $line = $fh->getline) {
        chomp($line);
        my @entry = split("\t", $line);
        $l++;
        if ($l == 1){
            foreach my $col (@entry){
                if ($col =~ /$expression_metric/i){
                    $metric_col = $c;
                }
                $c++;
            }
            next;
        }
        die "\n\nCould not find metric col for $expression_metric\n\n" unless (defined ($metric_col));

        my $gene_id = $entry[0];
        my $gene_name = $entry[1];
        my $ref = $entry[2];
        my $strand = $entry[3];
        my $start = $entry[4];
        my $end = $entry[5];
        my $exp = $entry[$metric_col];
        $exp{$gene_id}{exp} = $exp;
    }
    $fh->close;
    return(\%exp);
}


