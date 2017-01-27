# Lab 2

1/27/17, Titus Brown

Follows from [../lab1/README.md](Lab 1).

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

1. Run::

        curl -O http://dib-training.ucdavis.edu.s3.amazonaws.com/2017-ucdavis-igg201b/SRR2584857.fq.gz

## Mapping

1. Run the following commands to install bwa:

        cd
        curl -L https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.15.tar.bz2/download > bwa-0.7.15.tar.bz2

        tar xjvf bwa-0.7.15.tar.bz2
        cd bwa-0.7.15
        make

        sudo cp bwa /usr/local/bin

2. Make & change into a working directory:

        mkdir ~/work
        cd ~/work

3. Copy and gunzip the reference:

        cp ~/2017-ucdavis-igg201b/lab1/ecoli-rel606.fa.gz .
        gunzip ecoli-rel606.fa.gz
        
4. Prepare it for mapping:

        /usr/local/bin/bwa index ecoli-rel606.fa
        
5. Map!

        /usr/local/bin/bwa mem ecoli-rel606.fa ../SRR2584857_1.fastq.gz > SRR2584857_1.sam
        
6. Observe!

        head SRR2584857_1.sam

## REMEMBER TO TURN OFF YOUR EC2 INSTANCE
