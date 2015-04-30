#!/usr/bin/env perl

use warnings;
use strict;

while(<>){

  my @elements = split(",", $_);
  my $c = 0;
  foreach my $e (@elements){
    $c++;
    if ($e =~ /href/i){
      print $_;
      next;
    }
    $e =~ s/(\d{7,8})/\<a href=\"http\:\/\/www\.ncbi\.nlm\.nih\.gov\/pubmed\/$1\"\>$1\<\/a\>/g;
    $e .= "," unless ($c == scalar(@elements));
    print "$e";
  }

}

exit;
