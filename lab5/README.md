# Lab 5 - Assembling and evaluating microbial genomes

Learning objectives:

* run a simple sequence assembly.

* evaluate it.

* annotate it.

## Part I: running an assembler

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

## Some thoughts and questions

Question: why are there so many contigs?!

What is N50, and why is that the metric we use?  (vs NG50)

How might we evaluate the quality (...qualities) of this assembly?

## Part II: Mapping.

1. Run the following commands to install bwa:

        cd
        curl -L https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.15.tar.bz2/download > bwa-0.7.15.tar.bz2

        tar xjvf bwa-0.7.15.tar.bz2
        cd bwa-0.7.15
        make

        sudo cp bwa /usr/local/bin
        
        echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
        source ~/.bashrc

2. We will also need `khmer` (see [khmer docs](khmer.readthedocs.io)) and `samtools`.

        pip install khmer==2.0
        sudo apt-get -y install samtools

3. Split the reads:

        gunzip -c ecoli_ref-5m.fastq.gz | head -1000000 | 
             split-paired-reads.py -1 head.1 -2 head.2 
             
4. Map the reads:

        bwa index ecoli-assembly.fa 
        bwa aln ecoli-assembly.fa head.1 > head.1.sai 
        bwa aln ecoli-assembly.fa head.2 > head.2.sai 
        bwa sampe ecoli-assembly.fa head.1.sai head.2.sai head.1 head.2 > head.sam
        
5. Convert to BAM:

        samtools import ecoli-assembly.fai head.sam head.bam
        samtools sort head.bam head.sorted
        samtools index head.sorted.bam

6. Ask how many reads didn't align to the assembly:

        samtools view -c -f 4 head.sorted.bam

7. Ask how many reads **did** align to the assembly:

        samtools view -c -F 4 head.sorted.bam

### Questions:

Why would reads **not** align to the assembly?

(Cue extended rant by CTB on heuristics.)

## Part III: BLASTing

1. Install NCBI BLAST+:

        sudo apt-get -y install ncbi-blast+

2. Make the assembly BLAST-able:

        makeblastdb -dbtype nucl -in ecoli-assembly.fa
        
3. Grab an E. coli gene:

        curl -O http://www.uniprot.org/uniprot/P0ACJ8.fasta 

4. BLAST!

        tblastn -query P0ACJ8.fasta -db ecoli-assembly.fa
        
Do we see a reasonable match?
