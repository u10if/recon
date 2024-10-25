#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not Valid"
    echo "Usage: bash Recon-E-apktool.sh <Android-App(app.apk)>"
    exit 1
fi

appname=$(echo $1 | cut -d "." -f1)

echo "Run apktool & Extract Endpoints from apk app: $1 file"

# Decompile APK
apktool d $1 --output "$appname-dir"

# Extract endpoints and filter common domains
grep -IPhro "(https?://|http?://)[\w\.-/]+[\"'\*]" "$appname-dir/" | \
    sed 's/["\*]//g' | \
    sort -u | \
    grep -v "w3\|android\|github\|schemas.android\|google\|goo.gl" > "$appname-apk-Endpoint.txt"

# Cleanup
rm -rf "$appname-dir"

echo "apktool Done & result in $appname-apk-Endpoint.txt => len: $(cat $appname-apk-Endpoint.txt | wc -l)"