### Informatics for RNA-seq: A web resource for analysis on the cloud

THIS VERSION OF THE RNA-SEQ COURSE IS DEPRECATED. FOR CURRENT VERSION PLEASE VISIT: https://rnabio.org/

<hr>

An educational tutorial and working demonstration pipeline for RNA-seq analysis including an introduction to: cloud computing, next generation sequence file formats, reference genomes, gene annotation, expression analysis, differential expression analysis, alternative splicing analysis, data visualization, and interpretation.

This repository is used to store code and certain raw materials for a detailed RNA-seq tutorial.  To actually complete this tutorial, go to the <a href="https://github.com/griffithlab/rnaseq_tutorial/wiki">RNA-seq tutorial wiki</a>.

Citation:
Malachi Griffith\*, Jason R. Walker, Nicholas C. Spies, Benjamin J. Ainscough, Obi L. Griffith\*. 2015. <a href="http://dx.doi.org/10.1371/journal.pcbi.1004393">Informatics for RNA-seq: A web resource for analysis on the cloud</a>. PLoS Comp Biol. 11(8):e1004393.

\*To whom correspondence should be addressed: E-mail: mgriffit[AT]genome.wustl.edu, ogriffit[AT]genome.wustl.edu

Note: An archived version of this tutorial exists <a href="https://github.com/griffithlab/rnaseq_tutorial_v1">here</a>. This version is maintained for consistency with the published materials (<a href="http://dx.doi.org/10.1371/journal.pcbi.1004393">Griffith et al. 2015. PLoS Comp Biol.</a>) and for past students wishing to review covered material. However, we strongly suggest that you continue with the current version of the tutorial below.

### Want to contribute to the RNA-seq Wiki?

[Fork it and send a pull request.](https://github.com/griffithlab/rnaseq_tutorial_wiki.git)

<hr>

### Tutorial Table of Contents
<ol start="0">
  <li><strong>Module 0 - Introduction and Cloud Computing</strong></li>
  <ol start="i">
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Authors">Authors</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Citation">Citation and Supplementary Materials</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Syntax">Syntax</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Intro-to-AWS-Cloud-Computing">Intro to AWS Cloud Computing</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Logging-into-Amazon-Cloud">Logging into Amazon Cloud</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Unix-Bootcamp">Unix Bootcamp</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Environment">Environment</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Resources">Resources</a></li>
  </ol>
  <li><strong>Module 1 - Introduction to RNA sequencing</strong></li>
  <ol start="i">
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Installation">Installation</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Reference-Genome">Reference Genomes</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Annotation">Annotations</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Indexing">Indexing</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/RNAseq-Data">RNA-seq Data</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/PreAlignment-QC">Pre-Alignment QC</a></li>
  </ol>
  <li><strong>Module 2 - RNA-seq Alignment and Visualization</strong></li>
  <ol start="i">
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Adapter-Trim">Adapter Trim</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Alignment">Alignment</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/IGV-Tutorial">IGV</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/PostAlignment-Visualization">Alignment Visualization</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/PostAlignment-QC">Alignment QC</a></li>
  </ol>
  <li><strong>Module 3 - Expression and Differential Expression</strong></li>
  <ol start="i">
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Expression">Expression</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Differential-Expression">Differential Expression</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/DE-Visualization">DE Visualization</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Kallisto">Kallisto for Reference-Free Abundance Estimation</a></li>
  </ol>
  <li><strong>Module 4 - Isoform Discovery and Alternative Expression</strong></li>
  <ol start="i">
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Reference-Guided-Transcript-Assembly">Reference Guided Transcript Assembly</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/de-novo-Transcript-Assembly">de novo Transcript Assembly</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Transcript-Assembly-Merge">Transcript Assembly Merge</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Differential-Splicing">Differential Splicing</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Transcript-Assembly-Visualization">Splicing Visualization</a></li>
  </ol>
  <li><strong>Module 5 - De novo transcript reconstruction</strong></li>
    <ol start="i">
    <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Trinity-Assembly-And-Analysis">De novo RNA-Seq Assembly and Analysis Using Trinity</a></li>
    </ol>
  <li><strong>Module 6 - Functional Annotation of Transcripts</strong></li>
    <ol start="i">
    <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Trinotate-Functional-Annotation">Functional Annotation of Assembled Transcripts Using Trinotate</a></li>
    </ol>
  <li><strong>Appendix</strong></li>
  <ol start="i">
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Saving-Your-Results">Saving Your Results</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Abbreviations">Abbreviations</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Lectures">Lectures</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Solutions">Practical Exercise Solutions</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Integrated-Assignment">Integrated Assignment</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/Proposed-Improvements">Proposed Improvements</a></li>
   <li><a href="https://github.com/griffithlab/rnaseq_tutorial/wiki/AWS-Setup">AWS Setup</a></li>
  </ol>
</ol>

