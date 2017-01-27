# Lab 1

## Boot up an Amazon instance

1. Boot an AWS m4.large, running image ami-c72d7fa7; you can follow [these instructions](https://2016-feb-aws.readthedocs.io/boot.html).

2. Edit the security group "inbound rules" so that ports 22 and 8000
   are open to all. You can follow [these instructions](https://2016-feb-aws.readthedocs.io/configure-firewall.html).

3. Connect to your machine's Public IP at port 8000 in a Web browser, e.g.
   `http://52.53.yyy.xxx:8000`.

4. Start a `New...` `Terminal`, and then run `bash`.

5. Run `git clone https://github.com/ctb/2017-ucdavis-igg201b.git`

## Look at some FASTQ data

1. In a Web browser, go to [the ENA record for SRX1317384](https://www.ebi.ac.uk/ena/data/view/SRX1317384)

2. Copy the url for `Fastq files (ftp)`, `File 1`.

3. In your terminal, execute `curl -O ` and then paste in the URL.

4. Wait for it to download.  Notice how the file appears in the Jupyter console.

5. Run

        gunzip -c SRR2584857_1.fastq.gz | head
        
   Marvel at the FASTQ.

6. Install [FastQC](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/):

        sudo apt-get -y install fastqc openjdk-8-jre
       
7. Run FastQC:

        fastqc SRR2584857_1.fastq.gz

7. Download and open the resulting `SRR2584857_1_fastqc.zip` file by
   clicking on it in the console.  Find and view the
   `fastqc_report.html` in a Web browser.
   
There's a [nice tutorial](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/) on the FastQC web site for those who are interested in more.

## Mapping

1. Run the following commands to install bwa:

        cd
        curl -L https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.15.tar.bz2/download > bwa-0.7.15.tar.bz2

        tar xjvf bwa-0.7.15.tar.bz2
        cd bwa-0.7.15
        make

        sudo cp bwa /usr/local/bin

2. Make & change into a working directory:

        mkdir ~/work;
        cd ~/work

3. Copy and gunzip the reference:

        cp ~/2017-ucdavis-igg201b/lab1/ecoli-rel606.fa.gz .
        gunzip ecoli-rel606.fa.gz
        
4. Prepare it for mapping:

        /usr/local/bin/bwa index ecoli-rel606.fa
        
5. Map!

        /usr/local/bin/bwa aln ecoli-rel606.fa ../SRR2584857_1.fastq.gz > SRR2584857_1.sai
        
6. Convert!

        /usr/local/bin/bwa samse ecoli-rel606.fa SRR2584857_1.sai ../SRR2584857_1.fastq.gz > SRR2584857_1.sam

6. Observe!

        head SRR2584857_1.sam

## REMEMBER TO TURN OFF YOUR EC2 INSTANCE
