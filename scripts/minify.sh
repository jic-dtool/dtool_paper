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
