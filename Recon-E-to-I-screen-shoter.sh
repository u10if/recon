#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not Valid"
    echo "Usage: Recon-E-to-I-screen-shoter.sh <SubdomainList(example.com-live-domain.txt)>"
    exit 1
fi

file_name=$(echo $1 | sed "s/.txt//g")

echo "Start eyewitness for take screenshots from urls in file $1"
eyewitness \
    -f $1 \
    --web \
    --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:40.0) Gecko/20100101 Firefox/40.0" \
    --threads 15 \
    --no-prompt \
    -d "$file_name-shots"

echo "eyewitness Done & result in $file_name-shots dir"