# Lab / Homework 2

Due Thursday, Mar 2nd, 5pm.

To turn in, e-mail the link to the github repo to Titus at
ctbrown@ucdavis.edu

## Task: Quality trim reads before assembling them.

In [lab 5](../lab5/README.md), we downloaded 5m E. coli reads,
assembled them using megahit, and then used Quast to get some
assembly metrics.  But we didn't do *any* quality filtering on the
reads, so the reads may contain a bunch of adapters and erroneous
bases! What happens to the assembly if we do some minimally responsible
quality filtering?

Let's use
[Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) to find
out!

For the HW,

0. Record the commands used to do the below in a text file (`.txt`),
   exactly as run.  (You can omit installation commands, or leave them in,
   as you wish.)

1. Download the same 5m E. coli reads as before.

2. Use Trimmomatic to quality filter them with the following parameters:

        ...
        
   (See appendix of this HW for instructions on running Trimmomatic.)

3. Run the MEGAHIT assembler on the resulting quality-filtered reads; be sure
   to include the single-ended reads that were trimmed by Trimmomatic.

4. Use Quast to evaluate the assembly, and compare against the results
   from the previous assembly (without quality filtering).
   
One mildly tricky bit will be to split the paired-end reads in the E. coli
data download into two files containing single-ended reads, which is what
Trimmomatic wants.  You will then need to figure out how to feed these
reads back into MEGAHIT.

There are several ways to achieve this; perhaps the most
straightforward way is to work through the read manipulation commands
in [lab 6](../lab6/README.md), so that you can give MEGAHIT the same
format reads as before.

...but you will also need to figure out how to feed single-ended reads into
MEGAHIT.  Feel free to read the documentation... :)

## Submitting your homework

Create a new github repo in your account named something like ggg201b and
upload the text file of commands to that repo as 'trim-and-assemble.txt'.
Put a sentence or two about results and conclusions of the comparison at
the bottom of that file.

Then send Titus the URL of the text file on github at [ctbrown@ucdavis.edu](mailto:ctbrown@ucdavis.edu)

## Appendix: running Trimmomatic

1. Install Trimmomatic on your cloud instance:

        sudo apt-get -y install trimmomatic

2. Download the TruSeq3-PE adapters:

        wget https://anonscm.debian.org/cgit/debian-med/trimmomatic.git/plain/adapters/TruSeq3-PE.fa
    
3. Run Trimmomatic on your split reads, replacing the filenames in
   `<xyz>` with the appropriate inputs and outputs.

        TrimmomaticPE <r1 input read file> <r2 input read file> \
            <out-r1> <out-r2> <orphan1> <orphan2> \
            ILLUMINACLIP:TruSeq3-PE.fa:2:40:15 \
            LEADING:2 TRAILING:2 \
            SLIDINGWINDOW:4:2 \
            MINLEN:25
            
   Here, `<orphan1>` and `<orphan2>` will be sets of reads where their
   partner paired read has been removed, for whatever reason.

## Appendix: output of quast on the assembly from the untrimmed reads

```
All statistics are based on contigs of size >= 500 bp, unless otherwise noted (e.g., "# contigs (>= 0 bp)" and "Total length (>= 0 bp)" include all contigs).

Assembly                    ecoli-assembly
# contigs (>= 0 bp)         117           
# contigs (>= 1000 bp)      93            
# contigs (>= 5000 bp)      69            
# contigs (>= 10000 bp)     64            
# contigs (>= 25000 bp)     52            
# contigs (>= 50000 bp)     32            
Total length (>= 0 bp)      4577284       
Total length (>= 1000 bp)   4566196       
Total length (>= 5000 bp)   4508252       
Total length (>= 10000 bp)  4471041       
Total length (>= 25000 bp)  4296074       
Total length (>= 50000 bp)  3578894       
# contigs                   102           
Largest contig              246618        
Total length                4572412       
GC (%)                      50.74         
N50                         105708        
N75                         53842         
L50                         15            
L75                         30            
# N's per 100 kbp           0.00          
```
