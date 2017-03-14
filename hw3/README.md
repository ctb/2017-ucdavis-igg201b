# Lab / Homework 3

Due Tuesday, Mar 21st, 5pm.

To turn in, e-mail a link to the script on github to Titus at
[ctbrown@ucdavis.edu](mailto:ctbrown@ucdavis.edu) with "HW3" in the subject.

### The point of this homework

* figure out how to find & download new SRA data sets;

* learn how to update the relevant script(s) for RNAseq analysis;

* win!

## Task: add at least two more `wt` and two `mut` data sets to the lab8 analysis.

In [lab 8](../lab8/README.md), we downloaded 6 SRA records from the [Schurch et al., 2016](http://rnajournal.cshlp.org/content/22/6/839) paper.  Take four more (two `mut`, two `wt`) from their spreadsheet at

    https://github.com/bartongroup/profDGE48/blob/master/Preprocessed_data/ENAdata_ERP004763_sample_mapping.tsv

and add them to the analysis.

**Evaluate how many genes were gained and lost at an FDR of your choosing.**

As in HW2, create a text file with all of the commands; at the end of the text file, put in a few comments about number of genes lost and gained relative to lab 8.

This time, please explicitly make it into a shell script that can be run; all that you need to do is:

* make the commands exactly what you would run;
* put discussion and commentary after `#`, so that they will be ignored by the shell;

You will need to modify the `yeast.salmon.R` script to include the new data sets. Ideally, you would put that in your HW repo as well, and `git clone` your HW repo onto your amazon machine so that you have a record of everything you ran.

You can find the `yeast-edgeR.csv` file from lab 8 [here, on github]((https://github.com/ctb/2017-ucdavis-igg201b/blob/master/lab8/yeast-edgeR.csv).

### A checklist:

You'll need to:

* find four new SRA accession numbers from the sample mapping TSV above;
* get the FASTQ download links from the [European Nucleotide Archive](http://ena.ebi.ac.uk);
* download the data and run the salmon analysis on all 10 data sets;
* modify the R script from lab 8 to include the new analyses, including updating the sample names and replicate structure;

## Submitting your homework

Create a new github repo in your account named something like ggg201b and
upload the text file of commands to that repo as 'trim-and-assemble.txt'.
Put a sentence or two about results and conclusions of the comparison at
the bottom of that file.

Then send Titus the URL of the text file on github at [ctbrown@ucdavis.edu](mailto:ctbrown@ucdavis.edu) with 'HW3' in the subject line.

## Appendix: updating `yeast.salmon.R`

Here are the lines I updated to add two new data sets into the R analysis script between lab 7 and lab 8.  The lines starting with `<` were removed and the lines starting with `>` were added; changed lines are both "removed" and "added."

```
5a6
> "ERR458495.fastq.gz.quant.counts",
7c8,9
< "ERR458501.fastq.gz.quant.counts"
---
> "ERR458501.fastq.gz.quant.counts",
> "ERR458502.fastq.gz.quant.counts"
10c12
< labels=c("A", "B", "C", "D")
---
> labels=c("A", "B", "E", "C", "D", "F")
18c20
< group <- c(rep("I",2), rep("II",2))
---
> group <- c(rep("mut", 3), rep("wt", 3))
26c28
< et <- exactTest(dge, pair=c("I", "II"))
---
> et <- exactTest(dge, pair=c("wt", "mut"))
```

These are roughly the same lines you'll need to update for this HW.
