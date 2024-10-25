#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Args is not Valid"
    echo "Usage: bash Recon-E-Dns-enum.sh <Domain(example.com)> <SubdomainList(example.com.allSubdomains.txt)>"
    exit 1
fi

echo "Run shuffledns & Brute force on => $1"
shuffledns -d $1 -r /home/bugBounty/wordlist/dns-resolvers.txt -w /home/bugBounty/wordlist/dns-wordlist.txt -silent -o $1.shufflebrute-1st.txt
echo "shuffledns Done & result in $1.shufflebrute-1st.txt => len: $(cat $1.shufflebrute-1st.txt | wc -l)"

echo "Run dnsgen on ==> $1"
cat $2 $1.shufflebrute-1st.txt | sort -u | dnsgen -w /home/bugBounty/wordlist/dns-dnsgen-wordlist.txt - > $1.dnsgen.txt
echo "dnsgen Done & result in $1.dnsgen.txt => len: $(cat $1.dnsgen.txt | wc -l)"

echo "Run shuffledns & Resolving on => $1"
shuffledns -l $1.dnsgen.txt -r /home/bugBounty/wordlist/dns-resolvers.txt -silent -o $1.shufflebrute-resolve.txt
echo "shuffledns Done & result in $1.shufflebrute-resolve.txt => len: $(cat $1.shufflebrute-resolve.txt | wc -l)"

echo "All Resolving Subdomain: $(cat $1.shufflebrute-resolve.txt | wc -l)"
echo "Recon-E-Dns-enum.sh is Finished"
echo