# Lab 3

2/3/17, Daniel Standage, daniel.standage@gmail.com

Follows from [Lab 2](../lab2/README.md).

Learning objectives:

* understand the output of variant calling / VCF files.

* compare Python and bedtools approaches to analyzing variant locations.

## Boot up an Amazon instance

Goal: provide a platform to run stuff on.

1. Boot an AWS m4.large, running image ami-c72d7fa7; you can follow [these instructions](https://2016-feb-aws.readthedocs.io/boot.html).

2. Edit the security group "inbound rules" so that ports 22 and 8000
   are open to all. You can follow [these instructions](https://2016-feb-aws.readthedocs.io/configure-firewall.html).

3. Connect to your machine's Public IP at port 8000 in a Web browser, e.g.
   `http://52.53.yyy.xxx:8000`.

4. Start a `New...` `Terminal`, and then run `bash`.

5. Run:

        git clone https://github.com/ctb/2017-ucdavis-igg201b.git`

6. Install samtools:

        sudo apt-get -y install samtools

## Download data

Goal: get the outputs from lab 2, so we don't need to run all that stuff again!

1. Run:

        mkdir ~/work
        cd ~/work
        curl -O https://s3-us-west-1.amazonaws.com/dib-training.ucdavis.edu/2017-ucdavis-igg201b/SRR2584857-bam%2Bvcf.tar.gz
    
2. Unpack the files:

        tar xzf SRR2584857-bam%2Bvcf.tar.gz
    
3. Verify that you can run 'samtools tview':

        samtools tview SRR2584857.sorted.bam ecoli-rel606.fa

   (Use 'q' to exit the viewer)
   
## Look at the VCF file.

1. Look at the non-commented lines:

        grep -v ^# variants.vcf
        
   The first five columns: `CHROM  POS     ID      REF     ALT`
   
2. Examine one with tview:

        samtools tview SRR2584857.sorted.bam ecoli-rel606.fa -p ecoli:920514
        
   'q' to quit, left arrow to scroll a bit left.
   


