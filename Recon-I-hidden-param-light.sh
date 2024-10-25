#!/bin/bash

if [ $# -ne 3 ]
then
    echo "Args is not Valid"
    echo "Usage: bash Recon-I-hidden-Param-light.sh <Method(GET|POST|PUT|...)> <Url(http://example.com/param?key=value)> <Custom-param-wordlist(params.txt)>"
    exit 1
fi

domain_name=$(echo $2 | cut -d "/" -f3)

echo "Start x8 with Custom wordlist[$3] for $2 ..."
x8 -u "$2" \
    --wordlist $3 \
    --max 8 \
    --follow-redirects \
    -X $1 \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:40.0) Gecko/20100101 Firefox/40.0" \
    --output "$domain_name-x8-custom-$1.txt"

echo "x8 with $3 wordlist Done & result in $domain_name-x8-custom-$1.txt => len: $(cat "$domain_name-x8-custom-$1.txt" | wc -l)"