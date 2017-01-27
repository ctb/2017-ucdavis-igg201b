# Lab 2

1/27/17, Titus Brown

Follows from [Lab 1](../lab1/README.md).

Learning objectives:

* define and explore the concepts and implications of shotgun
  sequencing;
  
* explore coverage;

* understand the basics of mapping-based variant calling;

* (maybe) visualize mapping

## Boot up an Amazon instance

1. Boot an AWS m4.large, running image ami-c72d7fa7; you can follow [these instructions](https://2016-feb-aws.readthedocs.io/boot.html).

2. Edit the security group "inbound rules" so that ports 22 and 8000
   are open to all. You can follow [these instructions](https://2016-feb-aws.readthedocs.io/configure-firewall.html).

3. Connect to your machine's Public IP at port 8000 in a Web browser, e.g.
   `http://52.53.yyy.xxx:8000`.

4. Start a `New...` `Terminal`, and then run `bash`.

5. Run `git clone https://github.com/ctb/2017-ucdavis-igg201b.git`

## Download data

1. Run:

        curl -O http://dib-training.ucdavis.edu.s3.amazonaws.com/2017-ucdavis-igg201b/SRR2584857.fq.gz

## Map data

1. Run the following commands to install bwa:

        cd
        curl -L https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.15.tar.bz2/download > bwa-0.7.15.tar.bz2

        tar xjvf bwa-0.7.15.tar.bz2
        cd bwa-0.7.15
        make

        sudo cp bwa /usr/local/bin
        
        echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
        source ~/.bashrc

2. Make & change into a working directory:

        mkdir ~/work
        cd ~/work

3. Copy and gunzip the reference:

        cp ~/2017-ucdavis-igg201b/lab1/ecoli-rel606.fa.gz .
        gunzip ecoli-rel606.fa.gz
        
4. Prepare it for mapping:

        bwa index ecoli-rel606.fa
        
5. Map!

        bwa mem -t 4 ecoli-rel606.fa ../SRR2584857.fq.gz > SRR2584857.sam
        
6. Observe!

        head SRR2584857.sam
        
## Visualize mapping

1. Install samtools:

        sudo apt-get -y install samtools
        
2. Convert the SAM file into a BAM file:

        samtools import ecoli-rel606.fa.fai SRR2584857.sam SRR2584857.bam
        
3. Sort the BAM file by position in genome:

        samtools sort SRR2584857.bam SRR2584857.sorted
        
4. Index the BAM file so that we can randomly access it quickly:

        samtools index SRR2584857.sorted.bam
        
5. Visualize with `tview`:

        samtools tview SRR2584857.sorted.bam ecoli-rel606.fa
        
   `tview` commands of relevance:
   
   * left and right arrows scroll
   * `q` to quit
   * CTRL-h and CTRL-l do "big" scrolls

## Build our own variant caller!

Open up a new Python 3 notebook.

### Header matter

Place yourself in the working directory:
```
cd ~/work
```

Enable plotting, import plotting libraries

```
%matplotlib inline
import pylab, numpy

Write a small SAM parsing function:
```
def read_samfile(filename):
    for line in open(filename):
        if line.startswith('@'):
            continue
        line = line.split('\t')
        readname = line[0]
        refname = line[2]
        refpos = int(line[3])
        readseq = line[9]
        
        if refname == '*':
            continue
        
        yield readname, refname, refpos, readseq
```

Install 'screed', a FASTA/FASTQ reader, and read the reference genome
into memory:

```
!pip install screed
references = [ record.sequence for record in screed.open('ecoli-rel606.fa') ]
ecoli = references[0]
```


## REMEMBER TO TURN OFF YOUR EC2 INSTANCE
