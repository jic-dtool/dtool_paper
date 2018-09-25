#!/bin/bash

# Exit immediately on failure of a command.
set -e

# Read in the input dataset URI from the command line.
INPUT_URI=$1

# Process all the items in the input dataset.
for ITEM_ID in `dtool identifiers $INPUT_URI`; do
    # Fetch an item and process it.
    ITEM_ABSPATH=`dtool item fetch $INPUT_URI $ITEM_ID`
    gunzip -c $ITEM_ABSPATH | head -n 1
done
