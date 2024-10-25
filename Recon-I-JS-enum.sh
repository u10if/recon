#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not Valid"
    echo "Usage: bash Recon-I-JS-enum.sh <SubdomainList(example.com.live.txt)>"
    exit 1
fi

file_name=$(echo $1 | sed "s/.txt//g")
now_date=$(date "+%Y-%m-%d")

# Fetch JavaScript files
echo "Start getJS for crawl JSfile on $1 file:"
getJS --input $1 --complete --insecure --resolve --output "$file_name-getJS.txt"
echo "getJS Done & result in $file_name-getJS.txt => len: $(cat $file_name-getJS.txt | wc -l)"
echo

# Download JavaScript files
echo "Start Download JSfile on $1 file:"
mkdir -p "$file_name-JS-content--$now_date"
wget -i "$file_name-getJS.txt" \
    --directory-prefix="$file_name-JS-content--$now_date" \
    --quiet

echo "Download JSfile Done & result in $file_name-JS-content--$now_date Directory => len: $(ls "$file_name-JS-content--$now_date" | wc -l)"

# Generate MD5 checksums
echo "Start make md5sum JSfiles on $file_name-JS-content--$now_date Directory:"
for file in $(ls "$file_name-JS-content--$now_date")
do
    md5sum "$file_name-JS-content--$now_date/$file" | \
    awk -v file="$file" '{print $1 " : " file}' >> "$file_name-JS-md5sum--$now_date.txt"
done

echo "Make md5sum JSfiles Done & result in $file_name-JS-md5sum--$now_date.txt => len: $(cat "$file_name-JS-md5sum--$now_date.txt" | wc -l)"

# Run SecretFinder
echo "Start SecretFinder for find sensitive value on $file_name-JS-content--$now_date folder:"
SecretFinder -i "$file_name-JS-content--$now_date/*" -o cli > "$file_name-SecretFinder--$now_date.txt"
echo "SecretFinder Done & result in $file_name-SecretFinder--$now_date.txt => len: $(cat "$file_name-SecretFinder--$now_date.txt" | wc -l)"

echo "JS Enum is finished"
echo