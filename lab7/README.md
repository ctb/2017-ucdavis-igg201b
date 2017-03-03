# Lab 7 - RNAseq expression analysis

Learning objectives:

1. Run through a basic RNAseq analysis with salmon and edgeR.

2. Experience some statistics, look at some plots.

## Your basic RNAseq analysis

0. Start up a new cloud instance (as usual; see [lab 5](../lab5/README.md)).
   (m4.large is probably fine for this.)
   
1. Connect to Terminal. Run `bash`.

2. Install edgeR:

        cd
        git clone https://github.com/ctb/2017-ucdavis-igg201b.git
        
        sudo Rscript --no-save ~/2017-ucdavis-igg201b/lab7/install-edgeR.R

3. Install [salmon](https://salmon.readthedocs.io):

        cd
        curl -L -O https://github.com/COMBINE-lab/salmon/releases/download/v0.8.0/Salmon-0.8.0_linux_x86_64.tar.gz
        tar xzf Salmon-0.8.0_linux_x86_64.tar.gz
        export PATH=$PATH:$HOME/Salmon-latest_linux_x86_64/bin

4. Run:

        mkdir yeast
        cd yeast
        
5. Download some data from [Schurch et al, 2016](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/):

        curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458500/ERR458500.fastq.gz
        curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458501/ERR458501.fastq.gz
        curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458493/ERR458493.fastq.gz
        curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458494/ERR458494.fastq.gz
        
6. Download the yeast reference transcriptome:

        curl -O http://downloads.yeastgenome.org/sequence/S288C_reference/orf_dna/orf_coding.fasta.gz

7. Index the yeast transcriptome:

        salmon index --index yeast_orfs --type quasi --transcripts orf_coding.fasta.gz
    
8. Run salmon on all the samples:

        for i in *.fastq.gz
        do
            salmon quant -i yeast_orfs --libType U -r $i -o $i.quant --seqBias --gcBias
        done
        
   What do you think all this stuff with the bias is about?
   
   Read up on [libtype, here](https://salmon.readthedocs.io/en/latest/salmon.html#what-s-this-libtype)
        
9. Collect all of the sample counts:

        curl -L -O https://github.com/ngs-docs/2016-aug-nonmodel-rnaseq/raw/master/files/gather-counts.py
        python2 gather-counts.py


10. Run edgeR (in R) and take a look at the output:

        Rscript --no-save ~/2017-ucdavis-igg201b/lab7/yeast.salmon.R
        
   This will produce two files, `yeast-edgeR-MA-plot.pdf` and
   `yeast-edgeR-MDS.pdf`.
