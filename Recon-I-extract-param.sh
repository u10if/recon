#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not valid"
    echo "Usage: bash Recon-I-extract-param.sh <Crawl-domain-file(example.com-crawl.txt)>"
    exit 1
fi

file_name=$(echo $1 | sed "s/.txt//g")

# File extensions to exclude
EXCLUDE_EXTENSIONS="css|jpg|jpeg|png|svg|img|gif|exe|mp4|flv|pdf|doc|ogv|webm|wmv|webp|mov|mp3|m4a|m4p|ppt|pptx|scss|tif|tiff|ttf|otf|woff|woff2|bmp|ico|eot|htc|swf|rtf|image|rf"

# Extract parameters from source code
echo "Start fetchParam for extract parameters from source code:"
fetchParam \
    --urls $1 \
    --output "$file_name-fetchParam.txt" \
    --threads 15 \
    --silent 2>/dev/null
echo "fetchParam Done & result in $file_name-fetchParam.txt => len: $(cat $file_name-fetchParam.txt | wc -l)"

# Extract parameters from URLs
echo "Start unfurl extract parameters from urls:"
cat $1 | unfurl keys | grep -E "[A-Za-z0-9]{2}" | sort -u > "$file_name-urlParam.txt"
echo "unfurl Done & result in $file_name-urlParam.txt => len: $(cat $file_name-urlParam.txt | wc -l)"

# Extract paths from URLs
echo "Start unfurl extract paths from urls:"
cat $1 | \
    unfurl paths | \
    grep -vE "\.(${EXCLUDE_EXTENSIONS})$" | \
    sort -u > "$file_name-paths-unfurl.txt"
echo "unfurl Done & result in $file_name-paths-unfurl.txt => len: $(cat $file_name-paths-unfurl.txt | wc -l)"

# Combine all parameters
cat "$file_name-fetchParam.txt" "$file_name-urlParam.txt" | \
    sort -u > "$file_name-param-wordlist.txt"
echo "Finally all parameters in $file_name-param-wordlist.txt => len: $(cat $file_name-param-wordlist.txt | wc -l)"