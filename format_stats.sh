#!/bin/bash

function add_repo_to_columns() {
    REPO=$1
    gsed -Ee "s/(.*):(.*)/$REPO\t\1\t\2/"
}

function remove_junk() {
    # Remove anything without a colon and PR lines
    gsed -Ee '/^Processing PR .*$/d' | gsed -Ee '/:/!d'
}

function remove_percentile_rows() {
    # Remove cum freq rows
    gsed -Ee '/Cumulative Frequency.*$/d' | gsed -Ee '/^\s+[0-9]{2,3}\%/d'
}

usage() { 
echo "Cleans up the outout of the pr-stats command to a list like REPO KEY VALUE"
echo "Usage: cat repo.txt | $0 repo;" 1>&2; exit 1; }

if [ -z $1 ]; then
    usage;
fi

repo=$1;
remove_junk | remove_percentile_rows | add_repo_to_columns $repo

