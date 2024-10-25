#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not Valid"
    echo "Usage: bash Recon-I-robots-sitemap.sh <SubdomainList(example.com.live.txt)[URLs]>"
    exit 1
fi

file_name=$(echo $1 | sed "s/.txt//g")

# Scan for sitemaps
echo "Start robofinder for find sitemap.xml files on $1 file:"
for site in $(cat $1)
do
    robofinder -u "$site" --quiet --sitemap >> "$file_name-sitemap.txt" 2> /dev/null
    LinkHunter -u "$site" --sitemap --output "$file_name-tmp-sitemap.txt"
    cat "$file_name-tmp-sitemap.txt" >> "$file_name-sitemap.txt"
    rm "$file_name-tmp-sitemap.txt"
    sleep 0.5
done

echo "robofinder Done & result in $file_name-sitemap.txt => len: $(cat $file_name-sitemap.txt | wc -l)"
echo

sleep 5

# Scan for robots.txt
echo "Start robofinder for find robots.txt files on $1 file:"
for site in $(cat $1)
do
    robofinder -u "$site" --quiet --address >> "$file_name-robots.txt" 2>/dev/null
    
    # Fixed LinkHunter command (removed hash symbol)
    LinkHunter -u "$site" --robots --output "$file_name-tmp-robots.txt"
    cat "$file_name-tmp-robots.txt" >> "$file_name-robots.txt"
    rm "$file_name-tmp-robots.txt"
    sleep 0.5
done

echo "robofinder Done & result in $file_name-robots.txt => len: $(cat $file_name-robots.txt | wc -l)"