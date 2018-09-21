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
