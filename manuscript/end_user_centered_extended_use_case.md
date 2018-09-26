# dtool from the end users point of view

From an end users point of view there are some clear benefits to making use of
dtool.

- It provides a means to make data understandable in the future

This is achieved by providing a standardised way to annotate a dataset with
descriptive metadata.

dtool also makes it easy to:

- Back up raw data and archive old data
- Move data from expensive to more cost effective storage solutions

Both of the above are achieved by abstracting away file paths and the storage
technologies from the end user. In other words interacting with a dataset stored
in the cloud feels the same as interacting with a dataset stored on local disk.

The abstraction of file paths and storage technologies also provides a more
subtle benefit. It enables end users to write processing scripts that are
agnostic of where the data lives, making processing scripts more portable
and re-usable.

The ability to upload and download datasets to cloud storage solutions also
provides the benefit of enabling researchers to share datasets with
collaborators.


## Making sense of data

One of the challenges in starting work in a new lab is getting to grips with
old lab members' data. The person who generated the data is often no longer
around and substantial effort is often spent trying to understand the context
of the data and the way it has been structured.

dtool makes it easy to understand the context and content of a dataset by
packing the metadata with the data.  In other words one can quickly get from a
URI specifying the location of a dataset to an overview of the dataset.
The URL below represents a dataset hosted in Amazon S3 storage.

```
http://bit.ly/Ecoli-reads
```

To find out the name of this dataset one can use the ``dtool name`` command.

```
$ dtool name http://bit.ly/Ecoli-reads
Escherichia-coli-reads-ERR022075
```

In the example above dtool pulls out the name of the dataset from the
administrative metadata and prints it to the terminal.

To get more information about this dataset one can use the ``dtool readme
show`` command.

```
$ dtool readme show http://bit.ly/Ecoli-reads
---
description: Whole Genome Sequencing of Escherichia coli str. K-12 MG1655
design: Paired-end sequencing (2x100 base) of E. coli library
sample: E. coli K-12 strain MG1655
study: |
  Paired-end sequencing of the genome of Escherichia coli K-12 strain MG1655
  using the Illumina Genome Analyzer IIx
Library:
  Name: CT1093
  Instrument: Illumina Genome Analyzer IIx
  Strategy: WGS
  Source: GENOMIC
  Selection: RANDOM
  Layout: PAIRED
  Construction protocol: |
    Standard Illumina paired-end library construction protocol. Genomic DNA was
    randomly fragmented using nebulisation and a ~600 bp fraction (including
    adapters) was obtained by gel electrophoresis.
links:
  - SRA: https://www.ncbi.nlm.nih.gov/sra/ERX008638
  - ENA: https://www.ebi.ac.uk/ena/data/view/ERX008638
```

The command above pulls out the descriptive metadata from the dataset and
prints it to the terminal. In this case the descriptive metadata tells us,
amongst other things, that this dataset contains paired-end sequencing data
for E. coli K-12 strain MG1655.

To get an idea of the size of the dataset one can use the ``dtool summary`` command.

```
$ dtool summary http://bit.ly/Ecoli-reads
{
  "name": "Escherichia-coli-reads-ERR022075",
  "uuid": "faa44606-cb86-4877-b9ea-643a3777e021",
  "creator_username": "olssont",
  "number_of_items": 2,
  "size_in_bytes": 3858445043,
  "frozen_at": 1537950392.95
}
```

This reveals that the dataset contains two items and is just short of 4GB in
size. The items in the dataset can be listed using the ``dtool ls`` command.

```
$ dtool ls --verbose http://bit.ly/Ecoli-reads
8bda245a8cd526673aab775f90206c8b67d196af   1.8GiB  ERR022075_2.fastq.gz
9760280dc6313d3bb598fa03c5931a7f037d7ffc   1.7GiB  ERR022075_1.fastq.gz
```

In the above the ``-v/--verbose`` flag is used to return the size as well as
the identifier and the relative path of each item.

In summary the commands ``dtool readme show``, ``dtool summary`` and ``dtool
ls`` gives a clear overview of the context and content of a dataset.


## Backing up raw data and archiving old data

At the John Innes Centre we have several storage solutions, each one serving a
specific purpose.  Traditional relatively expensive file system storage is used
for processing data. S3 object storage with off-site backups is used for
storing raw data. A capacious storage system front-ended by iRODS is used for
archiving long term intermediate data. Because dtool abstracts away the
underlying storage solution the end users can use the same commands for
copying data to and from these differing storage systems. The ease of moving
data around can be illustrated by copying a dataset hosted in the cloud to
local disk.

```
$ dtool cp -q http://bit.ly/Ecoli-ref-genome .
file:///Users/olssont/Escherichia-coli-ref-genome
```

In the above the ``-q/--quiet`` flag is used to only return the URI specifying
the location that the dataset has been copied to, in this case a directory
named ``Escherichia-coli-ref-genome`` in the current working directory.

dtool makes it easy to copy a datasets between different storage solutions. It
therefore becomes easy to copy data to storage solutions setup for backing up
and archiving data.

## Generating inventories of datasets

One of the challenges of a running a research group is keeping track of all the
data being generated. As such it is useful to be able to list datasets and to
generate inventories of datasets. This can be achieved using the commands
``dtool ls`` and ``dtool inventory``.

The purpose of ``dtool ls`` is to provide an easy way to list names an URIs of
datasets. Below is an example of the ``dtool ls`` command listing three datasets stored in a directory named ``my_datasets`` (see the supplementary material for details on how to setup this directory).

```
$ dtool ls my_datasets
Escherichia-coli-reads-ERR022075
  file:///Users/olssont/my_datasets/Escherichia-coli-reads-ERR022075
Escherichia-coli-reads-ERR022075-minified
  file:///Users/olssont/my_datasets/Escherichia-coli-reads-ERR022075-minified
Escherichia-coli-ref-genome
  file:///Users/olssont/my_datasets/Escherichia-coli-ref-genome
```

The need for this command becomes more apparent when working with datasets
stored in the cloud. The command below lists datasets in the Amazon S3
bucket ``dtool-demo``. Note that the command below requires the user to have
permissions to read the bucket and as such will not work for the readers of the
paper, but is included for illustrative purposes.

```
$ dtool ls s3://dtool-demo/
e.coli-k12-reference
  s3://dtool-demo/0860eec7-50f0-4bb7-b251-a12626c44b4d
e.coli-k12-reads-minified
  s3://dtool-demo/418a6437-afc7-4bb8-8885-686a20174e54
e.coli-k12-reads
  s3://dtool-demo/e3dd30c7-f4aa-4656-a68e-726e8b7706a1
```

The ``dtool inventory`` command is intented to be able to provide reports of
datasets. The command below creates a report (``my_datasets.html``) listing all
the datasets in the ``my_datasets`` directory as a single HTML file that can be
shared with colleagues via email.

```
$ dtool inventory --format=html my_datasets > my_datasets.html
```

In summary the ``dtool ls`` command can be used to find data in a base URI and
``dtool inventory`` can be used to generate reports and web pages to make
datasets findable.


## Verifying the integrity of old data

In trying to reproduce the result of a computational workflow one can run into
the situations where the newly generated results don't match up with those
generated previously. One reason this may occur is if the input data has
become corrupted.

In order to be able to check whether or not this is the case dtool provides a means to verify the integrity of a dataset.

```
$ dtool verify Escherichia-coli-ref-genome
All good :)
```

The command above shows that the dataset contains the expected content. To illustrate what happens if a dataset becomes corrupted we can move a file out of the dataset.

```
$ mv Escherichia-coli-ref-genome/data/U00096.3.fasta .
$ dtool verify Escherichia-coli-ref-genome
Missing item: b445ff5a1e468ab48628a00a944cac2e007fb9bc U00096.3.fasta
```

In summary dtool provides a means to get clarity with regards to the integrity
of a dataset.

## Processing data

dtool provides programmatic access to the data in a dataset. This means that
one can use dtool to create scripts that abstract away the location of the
data.

For example to process all the items in a dataset one can use the ``dtool
identifiers`` command to list all the identifiers. To access the content of the
items one can then use the ``dtool item fectch`` command, which returns
the absolute path to a location from where the item can be read. For datasets
stored in the cloud the ``dtool item fetch`` includes a step to download the
item to local disk to ensure it can be read from the absolute path returned
by the command.

Below is a Bash script (``simple_processing.sh``) to illustrate this.  The
processing example extracts the first line from each dataset item, using
``gunzip`` and ``head``.

```
#!/bin/bash

# Read in the input dataset URI from the command line.
INPUT_DS_URI=$1

# Process all the items in the input dataset.
for ITEM_ID in `dtool identifiers $INPUT_DS_URI`; do
    echo "PROCESSING ITEM: $ITEM_ID"

    # Fetch an item and process it.
    ITEM_ABSPATH=`dtool item fetch $INPUT_DS_URI $ITEM_ID`
    gunzip -c $ITEM_ABSPATH | head -n 1
done
```

Running this ``simple_procssing.sh`` script on a dataset stored in the cloud is
illustrated below.

```
$ bash simple_processing.sh https://bit.ly/Ecoli-reads-minified
@ERR022075.1 EAS600_70:5:1:1158:949/2
@ERR022075.1 EAS600_70:5:1:1158:949/1
```

We can verify that this gives the same results as running the script on a
dataset stored on local disk by copying the dataset and re-running the script
on the local dataset.

```
$ LOCAL_DS_URI=`dtool cp -q https://bit.ly/Ecoli-reads-minified .`
$ bash simple_processing.sh $LOCAL_DS_URI
@ERR022075.1 EAS600_70:5:1:1158:949/2
@ERR022075.1 EAS600_70:5:1:1158:949/1
```

It is also possible to use dtool to store the output of processing scripts,
both in terms of data and metadata. In other words, it is possible to
implement scripts that implement dataset to dataset processing. This is
powerful as it allows the automation of aspects of data management.

The script below, called ``minfiy.sh``, uses this concept of dataset to dataset processing. It is worth noting that the script:

- Creates a name for the output dataset based on the input dataset name
- Creates an output dataset
- Processes all the items from the input dataset and adds the results to the
  output dataset
- Extracts the descriptive metadata from the input dataset as a base for the
  descriptive metadata of the output dataset
- Adds a reference to the input dataset and a description of how it was
  processed to the descriptive metadata of the output dataset

```
#!/bin/bash 

# Exit immediately on failure of a command.
set -e

# Read in the input from the command line.
INPUT_URI=$1
OUTPUT_BASE_URI=$2
NUM_LINES=4000

# Create a name for the output dataset based on the input dataset.
OUTPUT_NAME=`dtool name $INPUT_URI`-minified

# Create an open proto dataset.
OUTPUT_URI=`dtool create -q $OUTPUT_NAME $OUTPUT_BASE_URI`

# Process all the items in the input dataset and
# add the results to the output dataset.
for ITEM_ID in `dtool identifiers $INPUT_URI`; do

  # Fetch the item from the dataset and get an absolute path
  # from where its content can be accessed.
  ITEM_ABSPATH=`dtool item fetch $INPUT_URI $ITEM_ID`

  # Write the minified version of the item to a temporary file.
  TMP_MINIFIED=$(mktemp /tmp/minfied.XXXXXX)
  gunzip -c $ITEM_ABSPATH | head -n $NUM_LINES | gzip > $TMP_MINIFIED

  # Add the temporary file to the output dataset giving it the relpath
  # of the item from the input dataset.
  RELPATH=`dtool item relpath $INPUT_URI $ITEM_ID`
  dtool add item $TMP_MINIFIED $OUTPUT_URI $RELPATH

  # Cleanup.
  rm $TMP_MINIFIED
done

# Create descriptive metadata for the output dataset.
TMP_README=$(mktemp /tmp/dtool-readme.XXXXXX)
dtool readme show $INPUT_URI > $TMP_README
echo "minified:" >> $TMP_README
echo "  from_UUID: `dtool uuid $INPUT_URI`" >> $TMP_README
echo "  from_URI: $INPUT_URI" >> $TMP_README
echo "  content: first $NUM_LINES per item" >> $TMP_README

# Add the descriptive metadata to the output dataset.
dtool readme write $OUTPUT_URI $TMP_README

# Cleanup.
rm $TMP_README

# Finalise the output dataset.
dtool freeze $OUTPUT_URI
```

In the supplementary material there is a script that performs a Bowtie2
alignment. It takes as input a dataset with paired RNA sequencing reads, a
dataset with a reference genome and a base URI specifying where the output
dataset should be written to.  The command below shows the usage of this
script.

```
$ bash bowtie2_align.sh  \
  http://bit.ly/Ecoli-reads-minified  \
  http://bit.ly/Ecoli-ref-genome .
```

Running this command creates a dataset named
``Escherichia-coli-reads-ERR022075-minified-bowtie2-align`` in the current working diretory.

```
$ DS_URI=Escherichia-coli-reads-ERR022075-minified-bowtie2-align
```

The content of this dataset is a SAM file.

```
$ dtool ls $DS_URI
3ffaeaf15fc1f12417aadddb9617fb048e39509e  ERR022075.sam
```

The descriptive metadata gives information about how this SAM file was derived.

```
$ dtool readme show $DS_URI
---
description: bowtie2 alignment
input_reads_uri: http://bit.ly/Ecoli-reads-minified
ref_genome_uri: http://bit.ly/Ecoli-ref-genome
bowtie_version: bowtie2-align-s version 2.3.3
```

It is important to note that the metadata above was generated automatically by
the ``bowtie2_align.sh`` script.

In summary dtool provides a means to write processing scripts that are agnostic
to where the input data is stored, whether it be on local disk or in some
object storage system in the cloud. Furthemore, using dtool to store the data
generated from processing scripts allow researchers to automate parts of their
data management.


## Sharing data

It is possible to share datasets hosted in cloud storage such as Amazon S3
and Microsoft Azure storage.

Take for example the dataset represented by the URI below.

```
s3://dtool-demo/8ecd8e05-558a-48e2-b563-0c9ea273e71e
```

This is the dataset with the *E. coli* reference genome data.

```
$ dtool name s3://dtool-demo/8ecd8e05-558a-48e2-b563-0c9ea273e71e
Escherichia-coli-ref-genome
```

This URI can only be used by people that have been authorised to interact with
the ``dtool-demo`` Amazon S3 bucket. To make this dataset accessible to the
public one can use the ``dtool_publish_dataset`` command line utility.

```
$ dtool_publish_dataset -q s3://dtool-demo/8ecd8e05-558a-48e2-b563-0c9ea273e71e
https://dtool-demo.s3.amazonaws.com/8ecd8e05-558a-48e2-b563-0c9ea273e71e
```

It is now possible for anyone in the world to interact with this dataset using
the HTTPS URI returned by the ``dtool_publish_dataset`` command.

```
$ dtool name  \
   https://dtool-demo.s3.amazonaws.com/8ecd8e05-558a-48e2-b563-0c9ea273e71e
Escherichia-coli-ref-genome
```

To make life easier one can use a URL shortner like [Bit.ly](https://bitly.com)
to create a more user friendly URI. The example below refers to the same dataset as above. 

```
dtool name http://bit.ly/Ecoli-ref-genome
Escherichia-coli-ref-genome
```

In summary dtool makes it easy to share datasets with collaborators and to make
dataset  accessible to the research community.
