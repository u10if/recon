#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Args is not Valid"
    echo "Usage: bash Recon-I-hidden-Param-heavy.sh <Url(http://example.com[/param?key=value])> <Custom-param-wordlist(params.txt)>"
    exit 1
fi

domain_name=$(echo $1 | cut -d "/" -f3)

# x8 Custom Wordlist - GET
echo "Start x8 with Custom wordlist[GET]: $2 ..."
x8 -u "$1" \
    --wordlist "$2" \
    --max 8 \
    --follow-redirects \
    -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:40.0) Gecko/20100101 Firefox/40.0" \
    --output "$domain_name-x8-custom-get.txt"
echo "x8 with $2 wordlist Done & result in $domain_name-x8-custom-get.txt => len: $(cat $domain_name-x8-custom-get.txt | wc -l)"
sleep 10

# x8 Custom Wordlist - POST
echo "Start x8 with Custom wordlist[POST]: $2 ..."
x8 -u "$1" \
    --wordlist "$2" \
    --max 8 \
    --follow-redirects \
    -X POST \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko" \
    --output "$domain_name-x8-custom-post.txt"
echo "x8 with $2 wordlist Done & result in $domain_name-x8-custom-post.txt => len: $(cat $domain_name-x8-custom-post.txt | wc -l)"
sleep 10

# x8 Mixed Case Wordlist - GET
echo "Start x8 with param-mixescase-large.txt wordlist[GET] ..."
x8 -u "$1" \
    --wordlist /home/bugBounty/wordlist/x8-param-mixescase-large.txt \
    --max 8 \
    --follow-redirects \
    -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; Trident/7.0; rv:11.0) like Gecko" \
    --output "$domain_name-x8-mcase-l-get.txt"
echo "x8 with param-mixescase-large.txt wordlist Done & result in $domain_name-x8-mcase-l-get.txt => len: $(cat $domain_name-x8-mcase-l-get.txt | wc -l)"
sleep 10

# x8 Mixed Case Wordlist - POST
echo "Start x8 with param-mixescase-large.txt wordlist[POST] ..."
x8 -u "$1" \
    --wordlist /home/bugBounty/wordlist/x8-param-mixescase-large.txt \
    --max 8 \
    --follow-redirects \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:40.0) Gecko/20100101 Firefox/40.0" \
    -X POST \
    --output "$domain_name-x8-mcase-l-post.txt"
echo "x8 with param-mixescase-large.txt wordlist Done & result in $domain_name-x8-mcase-l-post.txt => len: $(cat $domain_name-x8-mcase-l-post.txt | wc -l)"
sleep 10

# Arjun Default Wordlist - GET
echo "Start arjun with default wordlist[GET]: db/large.txt ..."
arjun -u "$1" \
    -c 8 \
    -t 2 \
    --headers "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko" \
    -oT "$domain_name-arjun-default-get.txt"
echo "arjun with default wordlist Done & result in $domain_name-arjun-default-get.txt => len: $(cat $domain_name-arjun-default-get.txt | wc -l)"
sleep 10

# Arjun JSON Wordlist - GET
echo "Start arjun with default json wordlist[GET]: arjun-param-special.json ..."
arjun -u "$1" \
    -c 1 \
    -t 2 \
    --headers "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/600.8.9 (KHTML, like Gecko) Version/8.0.8 Safari/600.8.9" \
    -w /home/bugBounty/wordlist/arjun-param-special.json \
    -oT "$domain_name-arjun-default-j-get.txt"
echo "arjun with default wordlist Done & result in $domain_name-arjun-default-j-get.txt => len: $(cat $domain_name-arjun-default-j-get.txt | wc -l)"
sleep 10

# Arjun JSON Wordlist - POST
echo "Start arjun with default json wordlist[POST]: arjun-param-special.json ..."
arjun -u "$1" \
    -c 1 \
    -t 2 \
    -m POST \
    --headers "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" \
    -w /home/bugBounty/wordlist/arjun-param-special.json \
    -oT "$domain_name-arjun-default-j-post.txt"
echo "arjun with default wordlist Done & result in $domain_name-arjun-default-j-post.txt => len: $(cat $domain_name-arjun-default-j-post.txt | wc -l)"

echo "Parameter discovery completed!"