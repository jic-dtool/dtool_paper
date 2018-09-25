# Dtool from the end users point of view

From an end users point of view there are some clear benefits to making use of
Dtool.

- It provides a means to make data understandable in the future

This is achieved by providing a standardised way to annotate a dataset with
descriptive metadata.

Dtool also makes it easy to:

- Back up raw data and archive old data
- Move data from expensive to more cost effective storage solutions

Both of the above are achieved by abstracting away file paths and the storage
technology from the end user. In other words interacting with a dataset stored
in the cloud feels the same as interacting with a dataset stored on local disk.

The abstraction of file paths and storage technology also provides a more
subtle benefit. It enables end users to write processing scripts that are
agnostic of where the data lives, making the processing scripts more portable
and re-usable.

The ability to upload and download datasets to cloud storage solutions also
provides the benefit of enabling researchers to share datasets with
collaborators.


## Making sense of data

One of the challenges in starting work in a new lab is getting to grips with
old lab members' data. The person who generated the data is often no longer
around and substantial effort is often spent trying to understand the context
of the data and the way it has been structured.

Dtool makes it easy to understand the context and content of a dataset by
packing the metadata with the data.  In other words one can quickly get from a
URI specifying the location of a dataset to an overview of the dataset.
The URL below represents a dataset hosted in Amazon S3 storage.

```
http://bit.ly/Ecoli-k12-reads
```

To find out the name of this dataset one can use the ``dtool name`` command.

```
$ dtool name http://bit.ly/Ecoli-k12-reads
e.coli-k12-reads
```

In the example above Dtool pulls out the name of the dataset from the
administrative metadata and prints it to the terminal.

To get more information about this dataset one can use the ``dtool readme
show`` command.

```
$ dtool readme show http://bit.ly/Ecoli-k12-reads
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
$ dtool summary http://bit.ly/Ecoli-k12-reads
{
  "name": "e.coli-k12-reads",
  "uuid": "e3dd30c7-f4aa-4656-a68e-726e8b7706a1",
  "creator_username": "olssont",
  "number_of_items": 2,
  "size_in_bytes": 3858445043,
  "frozen_at": 1536667714.548652
}
```

This reveals that the dataset contains two items and is just short of 4GB in
size. The items in the dataset can be listed using the ``dtool ls`` command.

```
dtool ls --verbose http://bit.ly/Ecoli-k12-reads
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
archiving long term intermediate data. Because Dtool abstracts away the
underlaying storage solution the end users can use the same commands for
copying data to and from these different storage systems. The ease of moving
data around can be illustrated by copying a dataset hosted in the cloud to
local disk.

```
$ dtool cp -q http://bit.ly/Ecoli-k12-reference .
file:///Users/olssont/e.coli-k12-reference
```

In the above the ``-q/--quiet`` flag is used to only return the URI specifying
the location that the dataset has been copied to, in this case a directory
named ``e.coli-k12-reference`` in the current working directory.

- Create a dataset?
- Create dataset using ``--symlink-path`` flag?


## Generating inventories of datasets

One of the challenges of a running a research group is keeping track of all the
data being generated. As such it is useful to be able to list datasets and to
generate inventories of datasets. This can be achieved using the commands
``dtool ls`` and ``dtool inventory``.

The purpose of ``dtool ls`` is to provide an easy way to list names an URIs of
datasets. Below is an example of the ``dtool ls`` command listing three datasets stored in a directory named ``my_datasets``.

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
stored in the cloud. The command below lists the datasets in the Amazon S3
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
shared with colleages via email.

```
$ dtool inventory --format=html my_datasets > my_datasets.html
```

In summary the ``dtool ls`` command can be used to find data in a base URI and
``dtool inventory`` can be used to generate reports and web pages to make
datasets findable.


## Verifying the integrity of old data

- dtool verify


## Processing data

Dtool provides programmatic access to the data in a dataset. This means that
one can use dtool to create scripts that abstract away the location of the
data.

For example to process all the items in a dataset one can use the ``dtool
identifiers`` command to list all the identifiers. To access the content of the
items one can then use the ``dtool item fectch`` command, which returns
the absolute path to a location from where the item can be read. For datasets
stored in the cloud the ``dtool item fetch`` includes a step to download the
item to local disk to ensure it can be read from the absolute path returned
by the command.

Below is a bash script to illustrate the use of ``dtool identifers`` and
``dtool item fetch`` in processing data. In the example, the processing
consists of extracting the first line from each dataset item, using ``gunzip``
and ``head``.

```
#!/bin/bash -e

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
illustrated in the example below.

```
$ bash simple_processing.sh https://bit.ly/Ecoli-k12-reads
@ERR022075.1 EAS600_70:5:1:1158:949/2
@ERR022075.1 EAS600_70:5:1:1158:949/1
```

We can verify that this gives the same results as running the script on a
dataset stored on local disk by copying the dataset and re-running the script
on the local dataset.

```
$ LOCAL_DS_URI=`dtool copy -q https://bit.ly/Ecoli-k12-reads .`
$ bash simple_processing.sh $LOCAL_DS_URI
@ERR022075.1 EAS600_70:5:1:1158:949/2
@ERR022075.1 EAS600_70:5:1:1158:949/1
```

It is possible to go even further and implement Bash scripts that implement
dataset to dataset processing. This is powerful as it allows the automation
of some aspects of data management. In the supplementary material there is a
script that performs a Bowtie2 alignment. It takes as input a dataset with
paired RNA sequence reads, a dataset with a reference genome and a base URI
specifying where the output dataset should be written to.
The command below shows the usage of this Bowtie2 dataset to dataset script.

```
$ bash bowtie2_align.sh  \
  http://bit.ly/Ecoli-k12-reads-minified  \
  http://bit.ly/Ecoli-k12-reference .
```

Running this command creates a dataset named
``e.coli-k12-reads-minified-bowtie2-align`` in the current working dirctory.

The content of this dataset is a SAM file.

```
$ dtool ls e.coli-k12-reads-minified-bowtie2-align
eaf15fc1f12417aadddb9617fb048e39509e  ERR022075.sam
```

The descriptive metadata gives informaiton about how this SAM file was derived.

```
$ dtool readme show e.coli-k12-reads-minified-bowtie2-align
---
description: bowtie2 alignment
input_reads_uri: http://bit.ly/Ecoli-k12-reads-minified
ref_genome_uri: http://bit.ly/Ecoli-k12-reference
bowtie_version: bowtie2-align-s version 2.3.3
```

It is important to note that the metadata above was generated automaticaly by
the ``bowtie2_align.sh`` script.

In summary Dtool provides a means to write processing scripts that are agnostic
as to where the input data is stored, whether it be on local disk or in some object
storage system in the cloud. Furthemore, using Dtool to store the data
generated from processing scripts allow researchers to automate parts of their
data management tasks.


## Sharing data

It is possible to share datasets hosted in cloud storage such as Amazon S3
and Microsoft Azure storage.

**Replace this dataset with ``Ecoli-k12-reads``**

Take for example the dataset represented by the URI
s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337. This is a dataset with
some simulated lambda phage reads.

```
$ dtool name s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337
simulated-lambda-phage-reads
```

This URI can only be used by people that have been authorised to interact with
the ``dtool-demo`` Amazon S3 bucket. To make this dataset accessible to the
public one can use the ``dtool_publish_dataset`` command line utility.

```
$ dtool_publish_dataset -q s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337
https://dtool-demo.s3.amazonaws.com/af6727bf-29c7-43dd-b42f-a5d7ede28337
```

It is now possible for anyone in the world to interact with this dataset using
the returned HTTPS URI.

```
$ dtool name https://dtool-demo.s3.amazonaws.com/af6727bf-29c7-43dd-b42f-a5d7ede28337
simulated-lambda-phage-reads
```

To make life easier one can use a URL shortner like [Bit.ly](https://bitly.com)
to create a more user friendly URI. The example below refers to the same dataset as above. 

```
dtool name http://bit.ly/simulated-lambda-phage-reads
simulated-lambda-phage-reads
```

In summary dtool makes it easy to share datasets with collaborators and to make
dataset  accessible to the research community.
