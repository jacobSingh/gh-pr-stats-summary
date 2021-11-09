#!/bin/bash

usage() { echo "Usage: $0 stats_directory;" 1>&2; exit 1; }

if [ -z $1 ]; then
    usage;
fi

input_directory=$1

echo "Repo  Attr  Val"
for file in $input_directory/*.txt; do
f=`basename $file`
    ./format_stats.sh "${f%.*}" < $file
done;
