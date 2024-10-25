#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not Valid"
    echo "Usage: fuzz-Extractor.sh <file(fuzz-file.csv)>"
    exit 1
fi

file_name=$(echo $1 | sed "s/.csv//g")

echo "Start Extracting result of fuzzing host files with status code [20X, 30X, 401,403, 500] with csv extension"
sleep 2

# Extract 20X responses
cat $1 | grep -E "(\,20[0-8]{1}\,)" | cut -d "," -f1-2 > $file_name.20x.txt

# Extract 30X responses
cat $1 | grep -E "(\,30[0-8]{1}\,)" | cut -d "," -f1-2 > $file_name.30x.txt

# Extract 4XX responses
cat $1 | grep -E "(\,4[0-5]{1}[0-9]{1}\,)" | cut -d "," -f1-2 > $file_name.4xx.txt

# Extract 50X responses
cat $1 | grep -E "(\,50[0-1]{1}[0-9]{1}\,)" | cut -d "," -f1-2 > $file_name.50x.txt

# Print results
echo "Result with status Code 20X in $file_name.20x.txt => len: $(cat $file_name.20x.txt | wc -l)"
echo
echo "Result with status Code 30X in $file_name.30x.txt => len: $(cat $file_name.30x.txt | wc -l)"
echo
echo "Result with status Code 4XX in $file_name.4xx.txt => len: $(cat $file_name.4xx.txt | wc -l)"
echo
echo "Result with status Code 50X in $file_name.50x.txt => len: $(cat $file_name.50x.txt | wc -l)"
echo

echo "Extraction Complete!"