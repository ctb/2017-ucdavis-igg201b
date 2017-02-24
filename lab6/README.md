# Lab 6 - Miscellaneous assembly foo

Learning objectives:

1. Think about where assembly might fail, vs where mapping might fail.

2. Experience some GitHub.

3. Learn some commands for manipulation read files.

## 1. Assembly vs mapping

Up front question: if you recall, last week, we got 117 contigs. Why?
Why didn't the 

Broadly speaking, where does assembly fail?

What about mapping for variant calling - what are its problems?

When would you use assembly vs using mapping? (In groups, pick two
examples of each.)

## 2. Experience some GitHub.

GitHub is a place to put files for public (or private) consumption, and
to work with and edit them.  We'll talk more about that in the next
few weeks.

0. Start up a new cloud instance (as usual; see [lab 5](../lab5/README.md)).

1. Go to http://github.com/ and log in.

2. Create a new repository. (Name it whatever you like, but something
   like ggg201b-in-class might be simplest.)

3. On your local computer, create a text file and upload it to your
   new repository.
   
4. Copy the clone URL into your paste buffer, and then on your EC2 instance
   command line run:
   
        cd
        git clone <clone URL>
        
   Now do `ls`, and then `ls <repository name>`.
   
5. In your web browser, edit the file, and save the changes.

6. On your EC2 instance command line, run

        cd <repository name>
        
   followed by
   
        ls
        
   followed by
   
        cat <filename.txt>
        
   Cool, eh?
        
7. On the Web interface, take a look at "history".

## 3. Read manipulation

(This will be important for the HW.)

Install khmer:

    pip install khmer==2.0
    
and while it's installing, [take a look at the docs](https://khmer.readthedocs.io/en/v2.0/user/scripts.html#scripts-read-handling).

Grab the following E. coli data set:

    mkdir ~/work
    cd ~/work
    
    curl -O -L https://s3.amazonaws.com/public.ged.msu.edu/ecoli_ref-5m.fastq.gz
    
Look at the top:

    gunzip -c ecoli_ref-5m.fastq.gz | head
    
The `/1` and `/2` immediately following each other indicate that this is
an 'interleaved' or 'shuffled file'.

Select the first 100k reads and split them into 'left' and 'right' reads --

    gunzip -c ecoli_ref-5m.fastq.gz | head -400000 | \
        split-paired-reads.py -1 top.R1.fq -2 top.R2.fq

Now look at the top of `top.R1.fq`:

    head top.R1.fq
    
and `top.R2.fq`:

    head top.R2.fq
    
These files are now in the format you might get them from from a sequencing
facility - i.e. separated 'R1' and 'R2', but in registry (i.e. first FASTQ
record in `top.R1.fq` is the pair of the first FASTQ record in `top.R2.fq`.

Some programs like them one way, some programs like them the other way.

You can interleave them again by doing:

    interleave-reads.py top.R1.fq top.R2.fq > top-pe.fq
    
take a look at the output:

    head top-pe.fq

A few notes --

* having all the reads in the same (single) file is convenient;

* keeping the reads in registry if you do anything to them is tricky;
  e.g. imagine removing the first read in `top.R1.fq`, you have to also
  remove the first read in `top.R2.fq`!
  
* some programs will tell you if you got it wrong, others won't.
