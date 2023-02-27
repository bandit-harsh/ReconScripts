#! /bin/bash

# $1 - domain.com 
# $2 - Github Token file
if [ $# -eq 0 ]
  then
    echo "Usage: script.sh domain.com github_tokens.txt"
    exit 1
fi

amass enum --passive -d $1 -config ./config/amass.ini -o amass.txt
~/go/bin/subfinder -d $1 -all -config ./config/subfinder.yaml -o subfinder.txt 
~/go/bin/gau --timeout 5 --subs $1 | ~/go/bin/unfurl -u domains | tee -a gau.txt
~/go/bin/waybackurls $1 | ~/go/bin/unfurl -u domains | sort -u waybackurl.txt
~/go/bin/github-subdomains -d $1 -t $2 -o github.txt
curl "https://tls.bufferover.run/dns?q=.$1" -H 'x-api-key: MNzjhSSofn1DXUokUAO0n8PJuhpRWSh8asgNgrsW' | jq -r .Results[] | cut -d ',' -f5 | grep -F ".nxp.com" | tee -a buffer.txt
curl -s https://crt.sh/\?q\=\%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | ~/go/bin/httprobe | tee -a ./crtsh.txt

# sort and combine all the txt final.txt
cat amass.txt gau.txt subfinder.txt waybackurl.txt github.txt buffer.txt crtsh.txt | sort -u | tee -a ~/recon/passive-recon/final.txt
# Pass txt in puredns
mkdir ~/recon
mkdir ~/recon/passive-recon
~/go/bin/puredns resolve ~/recon/passive-recon/final.txt -r ~/tools/resources/resolvers.txt -w ~/recon/passive-recon/final-passive-resolved.txt

