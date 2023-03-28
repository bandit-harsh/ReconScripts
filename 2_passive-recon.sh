#! /bin/bash

# $1 - domain.com 
# $2 - Github Token file
if [ $# -eq 0 ]
  then
    echo "Usage: script.sh domain.com github_tokens.txt"
    exit 1
fi
mkdir ~/recon
mkdir ~/recon/raw-files	
rm -rf ~/recon/raw-files/*.txt
echo "$1""   "$(whois $1 | grep "Registrant Email" | egrep -ho "[[:graph:]]+@[[:graph:]]+") >> ~/recon/Registrant.txt
amass enum --passive -d $1 -config ./config/amass.ini -o ~/recon/raw-files/amass.txt
subfinder -d $1 -all -config ./config/subfinder.yaml -o ~/recon/raw-files/subfinder.txt 
~/go/bin/gau --timeout 5 --subs $1 | ~/go/bin/unfurl -u domains | tee ~/recon/raw-files/gau.txt
~/go/bin/waybackurls $1 | ~/go/bin/unfurl -u domains | tee ~/recon/raw-files/waybackurl.txt | sort -u ~/recon/raw-files/waybackurl.txt
~/go/bin/github-subdomains -d $1 -t $2 -o ~/recon/raw-files/github.txt
~/go/bin/assetfinder -subs-only $1 |  tee ~/recon/raw-files/assetfinder.txt
curl "https://tls.bufferover.run/dns?q=.$1" -H 'x-api-key: MNzjhSSofn1DXUokUAO0n8PJuhpRWSh8asgNgrsW' | jq -r .Results[] | cut -d ',' -f5 | grep -F ".$1" | tee ~/recon/raw-files/buffer.txt
curl -s https://crt.sh/\?q\=\%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | ~/go/bin/httprobe | tee  ~/recon/raw-files/crtsh.txt

# sort and combine all the txt final.txt
cat ~/recon/raw-files/*.txt | sed -E 's/^\s*.*:\/\///g'| sort -u | tee ~/recon/passive-recon/final.txt
# Pass txt in puredns
mkdir ~/recon
mkdir ~/recon/passive-recon
~/go/bin/puredns resolve ~/recon/passive-recon/final.txt -r ~/tools/resources/resolvers.txt -w ~/recon/passive-recon/final-passive-resolved.txt

