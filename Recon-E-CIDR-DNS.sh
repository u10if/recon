#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not Valid"
    echo "Usage: bash Recon-E-CIDR.sh <SubdomainList(example.com.allSubdomains.txt)>"
    exit 1
fi

file_name=$(echo $1 | sed "s/.txt//g")
echo "Run dnsx & Extract A record with: $1 file"
dnsx -a -resp-only -l $1 -r /home/bugBounty/wordlist/dns-resolvers.txt -o $file_name.ip-A-dnsx.txt -silent > /dev/null
echo "dnsx A-Record Done & result in $file_name.ip-A-dnsx.txt => len: $(cat $file_name.ip-A-dnsx.txt | wc -l)"
echo

echo "Run dnsx & Extract MX record with: $1 file"
dnsx -mx -resp -l $1 -r /home/bugBounty/wordlist/dns-resolvers.txt -o $file_name.domain-mx-dnsx.txt -silent > /dev/null
echo "dnsx MX-Record Done & result in $file_name.domain-mx-dnsx.txt => len: $(cat $file_name.domain-mx-dnsx.txt | wc -l)"
echo

echo "Run cut-cdn & Extract CDN IPs from: $1 file"
cut-cdn -i $file_name.ip-A-dnsx.txt -o $file_name.cut-cdn.txt -silent
echo "cut-cdn Done & result in $file_name.cut-cdn.txt => len: $(cat $file_name.cut-cdn.txt | wc -l)"
echo

echo "Start request to bgpview.io & find ASN-ip-range from $file_name.cut-cdn.txt"
> $file_name.all-ASN-ip-range.txt

while IFS= read -r ip
do
    sleep 1
    curl -s "https://api.bgpview.io/ip/$ip" | jq -r '.data.prefixes[].prefix' | head -n 1 >> $file_name.all-ASN-ip-range.txt
done < "$file_name.cut-cdn.txt"

sort -u $file_name.all-ASN-ip-range.txt > $file_name.ASN-ip-range.txt
rm $file_name.all-ASN-ip-range.txt

echo "bgpview.io request Done & result in $file_name.ASN-ip-range.txt => len: $(cat $file_name.ASN-ip-range.txt | wc -l)"
echo

echo "Start dnsx to resolve by PTR Record with $file_name.ASN-ip-range.txt"
cat $file_name.ASN-ip-range.txt | sort -u | dnsx -resp-only -ptr -r /home/bugBounty/wordlist/dns-resolvers.txt -silent -t 250 > $file_name.ptr.dnsx.txt
echo "dnsx-PTR Done & result in $file_name.ptr.dnsx.txt => len: $(cat $file_name.ptr.dnsx.txt | wc -l)"
echo

echo "Recon-E-CIDR.sh Finished!"