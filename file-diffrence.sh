#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Args is not valid"
    echo "Usage: bash file-difference.sh <file1> <file2>"
    echo "Shows lines that are in file2 but not in file1"
    exit 1
fi

grep -vxFf "$1" "$2"