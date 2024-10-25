#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Args is not Valid"
    echo "Usage: Recon-E-vhost.sh <Url> <Subdomains(example.com.Subs.txt)>"
    exit 1
fi

domain_name=$(echo $1 | cut -d "/" -f3)

echo "Start ffuf for FUZZ Host header with: \"Host: FUZZ\""
ffuf -u $1 -w /home/bugBounty/wordlist/fuzz-vhost.txt -ac \
    -H "Host: FUZZ" \
    -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36" \
    -fc 200,403,401 -t 1 -of csv -o $domain_name.vhost-FUZZ.csv
echo "FUZZ Host header Done & final result in $domain_name.vhost-FUZZ.csv => len: $(cat $domain_name.vhost-FUZZ.csv | wc -l)"
echo

echo "Start ffuf for FUZZ Host header with: \"Host: FUZZ.$domain_name\""
ffuf -u $1 -w /home/bugBounty/wordlist/fuzz-vhost.txt -ac \
    -H "Host: FUZZ.$domain_name" \
    -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.0" \
    -fc 200,403,401 -t 1 -of csv -o $domain_name.vhost-FUZZ.domain.csv
echo "FUZZ.$domain_name Host header Done & final result in $domain_name.vhost-FUZZ.domain.csv => len: $(cat $domain_name.vhost-FUZZ.domain.csv | wc -l)"
echo

echo "Start ffuf for FUZZ Host header with: \"Host: subdomain.$domain_name\""
ffuf -u $1 -w $2 -ac \
    -H "Host: FUZZ" \
    -H "User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36" \
    -fc 200,403,401 -t 1 -of csv -o $domain_name.vhost-FUZZ-subdomain.csv
echo "FUZZ.$domain_name Host header Done & final result in $domain_name.vhost-FUZZ-subdomain.csv => len: $(cat $domain_name.vhost-FUZZ-subdomain.csv | wc -l)"

cat $domain_name.vhost* | sort -u > $domain_name.vhosts-FUZZ.csv
echo "Host Header fuzzing finish and result in: $domain_name.vhosts-FUZZ.csv"
echo