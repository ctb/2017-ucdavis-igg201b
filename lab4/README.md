# Lab 4 - Assembly!

"Where do genomes come from, mommy?"

Learning objectives:

* understand the primary techniques used for de novo sequence assembly.

* run a simple sequence assembly.

## Part 1: assembly, by hand

Split up into groups of 3-6 people; see sheets of paper.

Rules:

* no googling!

Questions:

* think about strategy; how would you do this for 10x, or 100x, the data?

* does this get easier, or harder, with more people in a group?

* what are strategies for verifying the results?

* is it helpful that the "reads" are sorted?

## Part II: running an assembler

### Start up an AWS instance

Goal: provide a platform to run stuff on.

Boot an AWS m4.xlarge, running image ami-c72d7fa7; you can follow [these instructions](https://2016-feb-aws.readthedocs.io/boot.html).

Edit the security group "inbound rules" so that ports 22 and 8000
are open to all. You can follow [these instructions](https://2016-feb-aws.readthedocs.io/configure-firewall.html).

Connect to your machine's Public IP at port 8000 in a Web browser, e.g.
`http://52.53.yyy.xxx:8000`.

Start a `New...` `Terminal`, and then run `bash`.

### Install the MEGAHIT assembler

Check out and build [MEGAHIT](https://www.ncbi.nlm.nih.gov/pubmed/27012178):

    git clone https://github.com/voutcn/megahit.git
    cd megahit
    make -j 4

### Download an E. coli data set

Grab the following E. coli data set:

    mkdir ~/work
    cd ~/work
    
    curl -O -L https://s3.amazonaws.com/public.ged.msu.edu/ecoli_ref-5m.fastq.gz
    
### Run the assembler

Assemble the E. coli data set with MEGAHIT:

    ~/megahit/megahit --12 ecoli_ref-5m.fastq.gz -o ecoli

(This will take about 6 minutes.)  You should see something like:

    --- [STAT] 117 contigs, total 4577284 bp, min 220 bp, max 246618 bp, avg 39122 bp, N50 105708 bp
    --- [Fri Feb 10 14:33:59 2017] ALL DONE. Time elapsed: 342.060158 seconds ---

at the end.

Questions while we're waiting:

* how many reads are there?

* how long are they?

* are they paired end or single-ended?

* are they trimmed?

...and how would we find out?

Also, what expectation do we have for this genome in terms of size,
content, etc?

### Looking at the assembly

First, save the assembly:

    cp ecoli/final.contigs.fa ecoli-assembly.fa
    
Now, look at the beginning:

    head ecoli-assembly.fa
    
It's DNA! Yay!

### Measuring the assembly

Install [QUAST](http://quast.sourceforge.net/quast):

    cd ~/
    git clone https://github.com/ablab/quast.git -b release_4.2
    export PYTHONPATH=$(pwd)/quast/libs/

Run QUAST on your assembly:

    cd ~/work
    ~/quast/quast.py ecoli-assembly.fa -o ecoli_report
    
    python2.7 ~/quast/quast.py ecoli-assembly.fa -o ecoli_report

Now, in the browser, go look at `work/ecoli_report/report.txt`.
This contains a set of summary stats. Are they good?

## End of days

Question: why so many contigs?!
