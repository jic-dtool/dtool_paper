#!/usr/bash

# Usage  : ./create_reference_genome_dataset.sh <ACCESSION_ID>
# Example: ./create_reference_genome_dataset.sh U00096.3

# Exit immediately on failure of a command.
set -e

# Get the genome accession identifier from the command line.
ACCESSION_ID=$1

# Save working directory.
CUR_DIR=`pwd`

# Specify the URLs to use.
BASE_URL="https://www.ebi.ac.uk/ena/data/view/$ACCESSION_ID"
FASTA_URL="$BASE_URL&display=fasta"
TEXT_URL="$BASE_URL&display=text&header=true"

# Get the organism from the EMBL file format. 
ORGANISM=`curl $TEXT_URL | grep '^OS' | sed s'/^OS   //'`


# Create the proto dataset.
DS_NAME=`echo $ORGANISM | cut -d" " -f1 -f2 | sed s'/ /-/'`-ref-genome
echo $DS_NAME
dtool create -q $DS_NAME

# Move into the data directory.
cd $DS_NAME/data

# Download the genome from the ENA.
FNAME=$ACCESSION_ID.fasta
curl $FASTA_URL > $FNAME

# Build the Bowtie2 indices.
INDEX_BUILDER=bowtie2-build
INDEX_BUILD_CMD="$INDEX_BUILDER $FNAME reference"
$INDEX_BUILD_CMD

# Move back to the original directory
cd $CUR_DIR

# Add descriptive metadata.
README=$DS_NAME/README.yml
echo "description: $ACCESSION_ID genome with Bowtie2 indices" > $README
echo "organism: $ORGANISM" >> $README
echo "accession_id: $ACCESSION_ID" >> $README
echo "link: $BASE_URL" >> $README
echo "index_builder: `$INDEX_BUILDER --version | head -1`" >> $README
echo "index_build_cmd: $INDEX_BUILD_CMD" >> $README

# Freeze the dataset.
dtool freeze $DS_NAME
