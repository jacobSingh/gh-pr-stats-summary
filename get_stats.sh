#!/bin/bash
function get_repos() { 
    repo=$1
    curl -u "$GH_USER:$GH_TOKEN" -H "Accept: application/vnd.github.v3+json"  "https://api.github.com/orgs/$repo/repos?type=private&per_page=100" | jq '.[].name' | sed -e 's:"::g'
    echo 
}

function usage() { echo "Usage: $0 org [-o stats_directory];" 1>&2; exit 1; }

OUTPUT="."

while getopts ":o:" o; do
    case "${o}" in
        o)
            OUTPUT=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

mkdir -p $OUTPUT

if [ -z $1 ]; then
    usage;
fi
ORG=$1

if [ -z $GH_TOKEN ]; then
   echo "You must set the environment varaible GH_TOKEN"
   usage;
fi

if [ -z $GH_USER ]; then
   echo "You must set the environment varaible GH_USER"
   usage;
fi

set +x
echo "Getting stats for $ORG and putting in $OUTPUT"
for REPO in $(get_repos $ORG); do
    echo $REPO
    pr-stats --oauth $GH_TOKEN $ORG $REPO > $OUTPUT/$REPO.txt
done;
