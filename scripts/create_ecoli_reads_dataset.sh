#!/bin/bash

# Exit immediately on failure of a command.
set -e

# Specify the dataset name and data directory.
DS_NAME=Escherichia-coli-reads-ERR022075
DATA_DIR=$DS_NAME/data

# Create an open proto dataset.
dtool create -q $DS_NAME

# Add descriptive metadata to to proto dataset.
cat <<'EOF' | dtool readme write $DS_NAME -
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
EOF

# Add data to to proto dataset.
wget --directory-prefix $DATA_DIR ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR022/ERR022075/ERR022075_1.fastq.gz
wget --directory-prefix $DATA_DIR ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR022/ERR022075/ERR022075_2.fastq.gz 

# Convert the proto dataset into a dataset by freezing it.
dtool freeze $DS_NAME
