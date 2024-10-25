#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Args is not Valid"
    echo "Usage: Recon-E-nmap-ssl-cert.sh <Domain(example.com) [mainscope-for-grep]> <Ip-Range(example.com.ASN-ip-range.txt)>"
    exit 1
fi

echo "Start Nmap for with ssl-cert script on Ip range for $1"

nmap -iL $2 -T4 --min-hostgroup 512 -sS -Pn -p 21,22,23,25,53,80,110,161,389,443,445,587,636,993,995,1025,1701,1723,2000,2483,2484,2601,3000,3001,3128,3306,3389,3690,5060,5900,8000,8008,8080,8443,10443 --script ssl-cert -oN $1.nmap-ssl-cert-result.txt > /dev/null

cat $1.nmap-ssl-cert-result.txt | grep "ssl-cert: Subject: commonName=" | cut -d = -f2 | sort -u > $1.nmap-ssl-cert.all-domains.txt
cat $1.nmap-ssl-cert-result.txt | grep -E "Subject Alternative Name: DNS:" | cut -d : -f3 | sed 's/, DNS$//g' | sort -u >> $1.nmap-ssl-cert.all-domains.txt
cat $1.nmap-ssl-cert-result.txt | grep -E "Subject Alternative Name: DNS:" | cut -d : -f4 | sed 's/, DNS$//g' | sort -u >> $1.nmap-ssl-cert.all-domains.txt
cat $1.nmap-ssl-cert.all-domains.txt | sort -u | grep $1 > $1.nmap-ssl-cert-domain.txt

echo "Nmap ssl-cert Done & final result in $1.nmap-ssl-cert-domain.txt => len: $(cat $1.nmap-ssl-cert-domain.txt | wc -l)"
echo