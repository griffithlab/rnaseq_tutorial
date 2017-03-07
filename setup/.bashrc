# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


export PATH=$PATH:/home/ubuntu/tools/bowtie-1.1.2
export PATH=$PATH:/home/ubuntu/tools/bowtie2-2.2.9
export PATH=$PATH:/home/ubuntu/tools/trinityrnaseq-2.2.0
export PATH=$PATH:/home/ubuntu/tools/hisat2-2.0.4
export PATH=$PATH:/home/ubuntu/tools/sambamba_v0.6.4
export PATH=$PATH:/home/ubuntu/tools/stringtie-1.3.0.Linux_x86_64
export PATH=$PATH:/home/ubuntu/tools/gffcompare-0.9.8.Linux_x86_64
export PATH=$PATH:/home/ubuntu/tools/RSEM-1.2.31
export PATH=$PATH:/home/ubuntu/tools/cufflinks-2.2.1.Linux_x86_64
export PATH=$PATH:/home/ubuntu/tools/bedtools2/bin
alias picard='java -jar /home/ubuntu/tools/picard.jar'
export PATH=$PATH:/home/ubuntu/tools/MUMmer3.23
export PATH=$PATH:/home/ubuntu/tools/allpathslg-52488/bin
export PATH=$PATH:/home/ubuntu/tools/bin/Sniffles/bin/sniffles-core-1.0.0
export PATH=$PATH:/home/ubuntu/tools/ensembl-tools-release-86/scripts/variant_effect_predictor
export PATH=/home/ubuntu/tools/bin:/home/ubuntu/workspace/data/anaconda/bin:$PATH
export PATH=$PATH:/home/ubuntu/tools/VAAST_2.2.0/bin
export PATH=$PATH:/home/ubuntu/tools/speedseq/bin
export PATH=$PATH:/home/ubuntu/tools/hall_misc
export LD_LIBRARY_PATH=/home/ubuntu/tools/root/lib:$LD_LIBRARY_PATH

PATH="/home/ubuntu/tools/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/ubuntu/tools/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/ubuntu/tools/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/ubuntu/tools/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/ubuntu/tools/perl5"; export PERL_MM_OPT;

#RNA-seq specific environment variables
export RNA_HOME=~/workspace/rnaseq

export RNA_DATA_DIR=$RNA_HOME/data
export RNA_DATA_TRIM_DIR=$RNA_DATA_DIR/trimmed

export RNA_REFS_DIR=$RNA_HOME/refs
export RNA_REF_INDEX=$RNA_REFS_DIR/chr22_with_ERCC92
export RNA_REF_FASTA=$RNA_REF_INDEX.fa
export RNA_REF_GTF=$RNA_REF_INDEX.gtf

export RNA_ALIGN_DIR=$RNA_HOME/alignments/hisat2

export PATH=$PATH:$RNA_HOME/tools/samtools-1.3.1:$RNA_HOME/tools/bam-readcount/bin:$RNA_HOME/tools/hisat2-2.0.4:$RNA_HOME/tools/stringtie-1.3.0.Linux_x86_64:$RNA_HOME/tools/gffcompare-0.9.8.Linux_x86_64:$RNA_HOME/tools/HTSeq-0.6.1p1/scripts:$RNA_HOME/tools/R-3.2.3/bin:$RNA_HOME/tools/FastQC:$RNA_HOME/tools/flexbar_v2.5_linux64:$RNA_HOME/tools/bedtools2/bin

