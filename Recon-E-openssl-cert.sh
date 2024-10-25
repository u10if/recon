#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Args is not valid"
    echo "Usage: bash Recon-E-openssl-cert.sh <Domain(example.com)>"
    exit 1
fi

echo | openssl s_client -showcerts -servername $1 -connect $1:443 2>/dev/null | openssl x509 -inform pem -noout -text