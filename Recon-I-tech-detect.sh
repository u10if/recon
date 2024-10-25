#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not Valid"
    echo "Usage: bash Recon-I-tech-detect.sh <Domain(example.com)[Without-Schema]>"
    exit 1
fi

# Wappalyzer scan
echo "Start wappy for tech-detection site on $1:"
wappy --url $1 --writefile "$1.tech-wappy.txt" > /dev/null
echo "wappy Done & result in $1.tech-wappy.txt => len: $(cat "$1.tech-wappy.txt" | wc -l)"
echo

# WhatWeb scan
echo "Start whatweb for tech-detection site on $1:"
whatweb --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" \
    "http://$1" "https://$1" \
    --log-brief="$1.tech-whatweb.txt"
echo "whatweb Done & result in $1.tech-whatweb.txt => len: $(cat "$1.tech-whatweb.txt" | wc -l)"
echo

# Nuclei Project Discovery templates scan
echo "Start nuclei for tech-detection with Project Discovery templates site on $1:"
nuclei -u $1 \
    -t /home/bugBounty/vulnerability-Scan/nuclei/nuclei-templates/ \
    -tags tech \
    --headless \
    -rate-limit 5 \
    -headless-concurrency 5 \
    -o "$1.tech-nuclei-d.txt"
echo "nuclei Done & result in $1.tech-nuclei-d.txt => len: $(cat "$1.tech-nuclei-d.txt" | wc -l)"
echo

# Nuclei custom templates scan
echo "Start nuclei for tech-detection with Custom template site on $1:"
nuclei -u $1 \
    -t /home/bugBounty/vulnerability-Scan/nuclei/nuclei-template-mine/tech-Detect/ \
    -tags tech \
    --headless \
    -rate-limit 5 \
    -headless-concurrency 5 \
    -o "$1.tech-nuclei-c.txt"
echo "nuclei Done & result in $1.tech-nuclei-c.txt => len: $(cat "$1.tech-nuclei-c.txt" | wc -l)"
echo

# WAD scan
echo "Start wad for tech-detection site on $1:"
wad -u "http://$1" --format txt > "$1.tech-wad.txt"
wad -u "https://$1" --format txt >> "$1.tech-wad.txt"
echo "wad Done & result in $1.tech-wad.txt => len: $(cat "$1.tech-wad.txt" | wc -l)"
echo

# Wafw00f scan
echo "Start wafw00f for waf-detection site on $1:"
wafw00f -a --output "$1.tech-wafw00f.txt" $1
echo "wafw00f Done & result in $1.tech-wafw00f.txt => len: $(cat "$1.tech-wafw00f.txt" | wc -l)"

# Combine results and cleanup
cat "$1.tech-"*.txt > "$1.tech.detect.txt"
rm "$1.tech-"*.txt

echo "Final result in $1.tech.detect.txt"