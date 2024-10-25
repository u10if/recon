#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Args is not Valid"
    echo "Usage: bash Recon-I-crawl.sh <Domain(example.com)[mainscope-for-grep]> <SubdomainList(example.com.live.txt)>"
    exit 1
fi

# File extensions to exclude from crawling
EXCLUDE_EXTENSIONS="css|jpg|jpeg|png|svg|img|gif|exe|mp4|flv|pdf|doc|ogv|webm|wmv|webp|mov|mp3|m4a|m4p|ppt|pptx|scss|tif|tiff|ttf|woff|woff2|eot"

echo "Start katana for crawl site on $2 file:"
katana -list $2 \
    -depth 4 \
    -jsluice \
    -js-crawl \
    -known-files all \
    -automatic-form-fill \
    -form-extraction \
    -xhr-extraction \
    -silent \
    -no-sandbox \
    -output "$1.crawl-katana.txt"
echo "katana Done & result in $1.crawl-katana.txt => len: $(cat $1.crawl-katana.txt | wc -l)"
echo

echo "Start gauplus for crawl site on $2 file:"
cat $2 | gauplus -random-agent | grep -Eiv "\.(${EXCLUDE_EXTENSIONS})" | sort -u > "$1.crawl-gauplus.txt"
echo "gauplus Done & result in $1.crawl-gauplus.txt => len: $(cat $1.crawl-gauplus.txt | wc -l)"
echo

echo "Start gospider for crawl site on $2 file:"
gospider --sites $2 \
    --blacklist "\\.(${EXCLUDE_EXTENSIONS})" \
    --output "$1.crawl-gospider.dir"
cat "$1.crawl-gospider.dir"/* | grep -oE '(http.*)' | grep "$(echo $1 | cut -d "." -f1)" > "$1.crawl-gospider.txt"
echo "gospider Done & result in $1.crawl-gospider.txt => len: $(cat $1.crawl-gospider.txt | wc -l)"
echo

echo "Finally crawl finish!!!"
cat "$1.crawl-"* | grep -oE '(http.*)' | grep "$1" | sort -u > "$1.crawl-all.txt"
echo "$1.crawl-all.txt is created and has $(cat $1.crawl-all.txt | wc -l) unique URLs"