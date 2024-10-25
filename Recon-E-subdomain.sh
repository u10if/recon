#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not valid"
    echo "Usage: bash Recon-E-Subdomain.sh <Domain(example.com)>"
    exit 1
fi

echo "Run Subfinder ..."
subfinder -d $1 -all -silent -recursive > $1-subfinder.txt
echo "Subfinder Done & result in $1-subfinder.txt => len: $(cat $1-subfinder.txt | wc -l)"
echo

echo "Run gauplus ..."
echo $1 | gauplus -random-agent -subs | cut -d "/" -f3 | sort -u > $1-gauplus.txt
echo "gauplus Done & result in $1-gauplus.txt => len: $(cat $1-gauplus.txt | wc -l)"
echo

echo "Run sublist3r ..."
sublist3r -d $1 -t 10 -o $1-sublister.txt > /dev/null
echo "sublist3r Done & result in $1-sublister.txt => len: $(cat $1-sublister.txt | wc -l)"
echo

echo "Send Req to Crt.sh ..."
curl -s "https://crt.sh/?q=%25.$1%25&output=json" \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" \
    | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > $1-crtsh.txt
echo "Crt.sh Done & result in $1-crtsh.txt => len: $(cat $1-crtsh.txt | wc -l)"
echo

echo "Run amass ..."
amass enum -d $1 -passive -o $1-amass.txt > /dev/null
echo "amass Done & result in $1-amass.txt => len: $(cat $1-amass.txt | wc -l)"
echo

echo "Run assetfinder ..."
echo $1 | assetfinder --subs-only > $1-assetfinder.txt
echo "assetfinder Done & result in $1-assetfinder.txt => len: $(cat $1-assetfinder.txt | wc -l)"
echo

echo "Run waybackurls ..."
echo $1 | waybackurls | cut -d "/" -f3 | sort -u > $1-waybackurls.txt
echo "waybackurls Done & result in $1-waybackurls.txt => len: $(cat $1-waybackurls.txt | wc -l)"
echo

echo "Run github-subdomains ..."
github-subdomains -d $1 -k -e -q -o $1-github-subdomains.txt > /dev/null
echo "github-subdomains Done & result in $1-github-subdomains.txt => len: $(cat $1-github-subdomains.txt | wc -l)"

# Combine first round results
cat $1-*.txt | grep $1 | sort -u > $1-subs.txt

echo "Run Subfinder 2nd time..."
subfinder -dL $1-subs.txt -silent -recursive > $1-subfinder2nd.txt
echo "Subfinder2nd Done & result in $1-subfinder2nd.txt => len: $(cat $1-subfinder2nd.txt | wc -l)"

# Combine all results
cat $1-*.txt | grep $1 | sort -u > $1.allsubs.txt
rm $1-subs.txt

echo "All Subdomains: $(cat $1.allsubs.txt | wc -l)"
echo "Recon-E-Subdomain.sh is Finished"
echo