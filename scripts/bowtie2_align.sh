#!/bin/bash 

# Exit immediately on failure of a command.
set -e

# Read in the input from the command line.
READS_URI=$1
REF_GENOME_URI=$2
OUTPUT_BASE_URI=$3

# Specify the command for performing the alignment.
CMD=bowtie2

REF_DIR=`dtool name $REF_GENOME_URI`
REF_DATA_DIR=$REF_DIR/data
REF_DATA_PREFIX=$REF_DIR/data/reference

if [ ! -d $REF_DIR ]; then
    # The dataset has not been copied yet.
    dtool cp $REF_GENOME_URI .
fi

# Specify the name of the output dataset and create it.
OUTPUT_NAME=`dtool name $READS_URI`-bowtie2-align
OUTPUT_URI=`dtool create -q $OUTPUT_NAME $OUTPUT_BASE_URI`


# Perform the alignment and add the output file to the output dataset.
for ITEM_ID in `dtool identifiers $READS_URI`; do
  if [ `dtool item overlay is_read1 $READS_URI $ITEM_ID` = "True" ]; then
     PAIR_ID=`dtool item overlay pair_id $READS_URI $ITEM_ID`
     READ1_ABSPATH=`dtool item fetch $READS_URI $ITEM_ID`
     READ2_ABSPATH=`dtool item fetch $READS_URI $PAIR_ID`
     TMP_SAM=$(mktemp /tmp/sam_output.XXXXXX)
     $CMD -x $REF_DATA_PREFIX -1 $READ1_ABSPATH -2 $READ2_ABSPATH -S $TMP_SAM
     SAM_NAME=`dtool item overlay useful_name $READS_URI $ITEM_ID`.sam
     dtool add item $TMP_SAM $OUTPUT_URI $SAM_NAME
     rm $TMP_SAM
  fi
done

# Create descriptive metadata for the output dataset.
TMP_README=$(mktemp /tmp/dtool-readme.XXXXXX)
echo "description: bowtie2 alignment" > $TMP_README
echo "input_reads_uri: $READS_URI" >> $TMP_README
echo "ref_genome_uri: $REF_GENOME_URI" >> $TMP_README
echo "bowtie_version: `$CMD --version | head -1`" >> $TMP_README
cat $TMP_README

# Add the descriptive metadata to the output dataset
dtool readme write $OUTPUT_URI $TMP_README

rm $TMP_README

# Finalise the output dataset.
dtool freeze $OUTPUT_URI
