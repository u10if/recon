#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not valid"
    echo "Usage: Recon-E-live-domains.sh <SubdomainList(example.com-allsubdomain.txt)>"
    exit 1
fi

file_name=$(echo $1 | sed "s/.txt//g")

echo "Start Run httpx for find live subdomains, take shots & hash..."
cat $1 | httpx \
    -status-code \
    -content-length \
    -content-type \
    -location \
    -favicon \
    -hash md5 \
    -title \
    -web-server \
    -tech-detect \
    -websocket \
    -ip \
    -threads 40 \
    -rate-limit 10 \
    -tls-probe \
    -csp-probe \
    -vhost \
    -store-response \
    -store-chain \
    -cdn \
    -exclude-cdn \
    -silent \
    -follow-redirects \
    -filter-code 404 \
    -random-agent \
    -store-response-dir "$file_name-httpx-dir" \
    -output "$file_name-live-httpx.txt"

echo "httpx is finished and Result in: $file_name-httpx-dir & $file_name-live-httpx.txt"
echo "Total live domains found: $(cat $file_name-live-httpx.txt | wc -l)"