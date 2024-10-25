#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not Valid"
    echo "Usage: bash Recon-I-hidden-header-heavy.sh <Url(http://example.com)>"
    exit 1
fi

domain_name=$(echo $1 | cut -d "/" -f3)

# Lowercase headers with GET
echo "Start x8 with lowercase header wordlist[GET]: x8-header-lowercase.txt ..."
x8 -u "$1" \
    --headers \
    --max 10 \
    --follow-redirects \
    --wordlist /home/bugBounty/wordlist/x8-header-lowercase.txt \
    --output "$domain_name-x8-header-low-get.txt"
echo "x8 with x8-header-lowercase.txt wordlist Done & result in $domain_name-x8-header-low-get.txt => len: $(cat $domain_name-x8-header-low-get.txt | wc -l)"
sleep 10

# Uppercase headers with GET
echo "Start x8 with uppercase header wordlist[GET]: x8-header-uppercase.txt ..."
x8 -u "$1" \
    --headers \
    --max 10 \
    --follow-redirects \
    --wordlist /home/bugBounty/wordlist/x8-header-uppercase.txt \
    --output "$domain_name-x8-header-up-get.txt"
echo "x8 with x8-header-uppercase.txt wordlist Done & result in $domain_name-x8-header-up-get.txt => len: $(cat $domain_name-x8-header-up-get.txt | wc -l)"
sleep 10

# Lowercase headers with POST
echo "Start x8 with lowercase header wordlist[POST]: x8-header-lowercase.txt ..."
x8 -u "$1" \
    --headers \
    -X POST \
    --max 10 \
    --follow-redirects \
    --wordlist /home/bugBounty/wordlist/x8-header-lowercase.txt \
    --output "$domain_name-x8-header-low-post.txt"
echo "x8 with x8-header-lowercase.txt wordlist Done & result in $domain_name-x8-header-low-post.txt => len: $(cat $domain_name-x8-header-low-post.txt | wc -l)"
sleep 10

# Uppercase headers with POST
echo "Start x8 with uppercase header wordlist[POST]: x8-header-uppercase.txt ..."
x8 -u "$1" \
    --headers \
    -X POST \
    --max 10 \
    --follow-redirects \
    --wordlist /home/bugBounty/wordlist/x8-header-uppercase.txt \
    --output "$domain_name-x8-header-up-post.txt"
echo "x8 with x8-header-uppercase.txt wordlist Done & result in $domain_name-x8-header-up-post.txt => len: $(cat $domain_name-x8-header-up-post.txt | wc -l)"

echo "Hidden Headers Discovery Finished!"