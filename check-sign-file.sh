#!/bin/bash

RED='\033[0;31m'
GRN='\033[1;32m'
YEL='\033[0;33m'
BLU='\033[1;34m'
END='\033[0m' # No Color


filename=$1
sign=${2:-"$filename.signature"}


date=$(date -I)

if [ $# -eq 0 ]
  then
    echo "Usage: ./check-sign-file.sh <filename> [filename.signature] [public-keyfile]"
    exit 1
fi

if [ ! -f $sign ]; then
    printf $RED"Sign file not found!\n"$END
    exit 1
fi

echo "Getting Aleksei Krugliak publickey..."
curl https://raw.githubusercontent.com/ksemele/digital-signature/main/akrugliak-publickey.pem > akrugliak-publickey.pem
echo "[$date] successfully get key"

public_key=akrugliak-publickey.pem

echo "Verifiying file [$filename] signed by [$public_key] sign-file [$sign]"

printf $BLU
echo "openssl dgst -sha256 -verify $public_key -signature $sign $filename"
echo ""
printf $END

result=$(openssl dgst -sha256 -verify $public_key -signature $sign $filename | awk '{print $2}')

if [ $result == "Failure" ]; then
    printf $RED"Verifiying file [$filename]: $result\n"$END 
else
    printf $GRN"Verifiying file [$filename]: $result\n"$END 
fi

echo ""
echo "rm -rf akrugliak-publickey.pem"
rm -rf akrugliak-publickey.pem
printf $GRN"done.\n"$END
