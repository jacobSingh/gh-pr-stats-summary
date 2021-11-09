#!/bin/bash
function get_repos() { 
    org=$1
    type="private"
    if [ -n $GH_STATS_REPO_TYPE ]; then
        type=$GH_STATS_REPO_TYPE
    fi
    curl -u "$GH_USER:$GH_TOKEN" -H "Accept: application/vnd.github.v3+json"  "https://api.github.com/orgs/$org/repos?type=$type&per_page=100" | jq '.[].name' | sed -e 's:"::g'
    echo 
}

function usage() { echo "Usage: $0 [-o stats_directory] org;
For public repos, set env variable GH_STATS_REPO_TYPE to public" 1>&2; exit 1; }

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
    # pr-stats isn't mobile, so moving over there 
    cd $(dirname `which pr-stats`)
    pwd
    pr-stats --oauth $GH_TOKEN $ORG $REPO > $OUTPUT/$REPO.txt
    cd -
done;
