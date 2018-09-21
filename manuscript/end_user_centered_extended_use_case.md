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
on local disk feels the same as interacting with a dataset stored in the cloud.

The abstraction of file paths and storage technology also provides a more
subtle benefit. It enables end users to write processing scripts that are
agnostic of where the data lives, making the processing scripts more portable
and re-usable.

The ability to upload and download a dataset to a cloud storage solutions also
provides the benefit of enabling researchers to share datasets with
collaborators.

## Making sense of data

One of the challenges in starting work in a new lab is getting to grips with
old lab member's data. The person who generated the data is often no longer
around and substantial effort is often spent trying to understand the context
of the data and the way it has been structured.

Dtool makes it easy to understand the context and content of a dataset making
it possible to quickly got from a URI specifying the location of a dataset
to an overview of the dataset. Below is a shortened URL that redirects to a
dataset hosted in Amazon S3 storage.

```
http://bit.ly/Ecoli-k12-reads
```

To find out the name of this dataset one can use the ``dtool name`` command.

```
$ dtool name http://bit.ly/Ecoli-k12-reads
e.coli-k12-reads
```

In the example above Dtool follows the redirection and pulls out the name of
the dataset from its administrative metadata and prints it to the terminal.

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

At the John Innes Centre we have several storage solutions for storing
different types of data. Traditional relatively expensive file system storage
is used for processing data. S3 object storage with two replicas on site and
one off-site is used for storing raw data. A capacious storage system
front-ended by iRODS is used for archiving historical data. Because Dtool
abstracts away the underlaying storage solution the end users can use the same
commands for copying data to and from these different storage systems. This can
be illustrated by copying a dataset hosted in the cloud to local disk.

```
$ dtool cp -q http://bit.ly/Ecoli-k12-reference .
file:///Users/olssont/e.coli-k12-reference
```

In the above the ``-q/--quiet`` flag is used to only return the URI specifying
the location that the dataset has been copied to, in this case a directory
named ``e.coli-k12-reference`` in the current working directory.

- Create a dataset?
- Create dataset using ``--symlink-path`` flag?


## Processing data

- See the supplementary material to find the scripts used to create the reference genome dataset


## Sharing data

It is possible to share datasets hosted in cloud storage such as Amazon S3
and Microsoft Azure storage.

Take for example the dataset represented by the URI
s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337. This is a dataset with
some simulated lambda phage reads.

```
$ dtool name s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337
simulated-lambda-phage-reads
```

This URI can only be used by people that have been authorised to interact with
the ``dtool-demo`` Amazon S3 bucket. To make this dataset accessible in the
public domain one can use the ``dtool_publish_dataset`` command line utility.

```
$ dtool_publish_dataset s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337
Dataset accessible at: https://dtool-demo.s3.amazonaws.com/af6727bf-29c7-43dd-b42f-a5d7ede28337
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
