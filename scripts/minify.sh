#!/bin/bash 

# Exit immediately on failure of a command.
set -e

# Read in the input from the command line.
INPUT_URI=$1
OUTPUT_BASE_URI=$2
NUM_LINES=4000

echo $INPUT_URI

OUTPUT_NAME=`dtool name $INPUT_URI`-minified
echo $OUTPUT_NAME
echo $OUTPUT_BASE_URI

OUTPUT_URI=`dtool create -q $OUTPUT_NAME $OUTPUT_BASE_URI`

for ITEM_ID in `dtool identifiers $INPUT_URI`; do
  ITEM_ABSPATH=`dtool item fetch $INPUT_URI $ITEM_ID`
  RELPATH=`dtool item relpath $INPUT_URI $ITEM_ID`
  TMP_MINIFIED=$(mktemp /tmp/minfied.XXXXXX)
  gunzip -c $ITEM_ABSPATH | head -n $NUM_LINES | gzip > $TMP_MINIFIED
  dtool add item $TMP_MINIFIED $OUTPUT_URI $RELPATH
  rm $TMP_MINIFIED
done

# Create descriptive metadata for the output dataset.
TMP_README=$(mktemp /tmp/dtool-readme.XXXXXX)
dtool readme show $INPUT_URI > $TMP_README
echo "minified:" >> $TMP_README
echo "  from_UUID: `dtool uuid $INPUT_URI`" >> $TMP_README
echo "  from_URI: $INPUT_URI" >> $TMP_README
echo "  content: first $NUM_LINES per item" >> $TMP_README

# Add the descriptive metadata to the output dataset
dtool readme write $OUTPUT_URI $TMP_README
rm $TMP_README

# Finalise the output dataset.
dtool freeze $OUTPUT_URI
