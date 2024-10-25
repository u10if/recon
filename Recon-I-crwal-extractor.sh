#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not valid"
    echo "Usage: Recon-I-crawl-extractor.sh <file(example.com-crawl.txt)|(*.crawl.txt)>"
    exit 1
fi

sleep 2
echo "Start extract urls with (.php|.js|.jsp|.asp|.aspx) extension & with or without parameter"

file_name=$(echo $1 | sed "s/.txt//g")

# Extract URLs by extension
cat $1 | grep -E "(\w+\.aspx(\?|$)|\w+\.asp(\?|$))" | sort -u > "$file_name-asp.txt"
cat $1 | grep -E "\w+\.php(\?|$)" | sort -u > "$file_name-php.txt"
cat $1 | grep -E "\w+\.js(\?|$)" | sort -u > "$file_name-js.txt"
cat $1 | grep -E "\w+\.jsp(\?|$)" | sort -u > "$file_name-jsp.txt"

# Extract URLs with and without parameters
cat $1 | grep "?" | sort -u > "$file_name-hashParam.txt"
cat $1 | grep -v "?" | sort -u > "$file_name-noParam.txt"

# Print results
echo "Result with asp|aspx extension extracted in $file_name-asp.txt => len: $(cat $file_name-asp.txt | wc -l)"
echo "Result with php extension extracted in $file_name-php.txt => len: $(cat $file_name-php.txt | wc -l)"
echo "Result with js extension extracted in $file_name-js.txt => len: $(cat $file_name-js.txt | wc -l)"
echo "Result with jsp extension extracted in $file_name-jsp.txt => len: $(cat $file_name-jsp.txt | wc -l)"
echo "Result with parameters extracted in $file_name-hashParam.txt => len: $(cat $file_name-hashParam.txt | wc -l)"
echo "Result without parameters extracted in $file_name-noParam.txt => len: $(cat $file_name-noParam.txt | wc -l)"
echo