# Gen of Priority wordlist from ~/recon/passive-recon/final.txt ~/recon/active-recon/bruteforce.txt ~/recon/active-recon/final-Resolved.txt
# For Bucket Finding and bruteforce
# $1 - target.com
# $2 - target
# $3 - product made by company
RED='\033[0;31m'
NC='\033[0m' 
if [ $# -eq 0 ]
  then
    echo "Usage: script.sh domain.com domain <product made by company>"
    exit 1
fi
echo "${RED}Make sure you have setup the awscli${NC}"
mkdir ~/recon/cloud-assets
cat ~/recon/passive-recon/final.txt ~/recon/active-recon/bruteforce.txt ~/recon/active-recon/final-Resolved.txt | sed 's/\./\n/g' | sort -u | tee -a ~/recon/cloud-assets/words.txt
cat ~/recon/cloud-assets/words.txt | sed -E 's/$/\.s3.amazon.com/' | tee -a ~/recon/cloud-assets/buckets.txt
~/tools/slurp/slurp-1.1.0-linux-amd64 domain -p ~/tools/slurp/permutations.json -t $1 -c 25 | tee -a ~/recon/cloud-assets/slurp-data.txt

S3scanner scan --buckets-file buckets.txt | tee -a ~/recon/cloud-assets/s3scanner.txt

~/tools/cloud_enum/cloud_enum.py -k $1 -k $2 -k $3 -l ~/recon/cloud-assets/cloud-enum.txt
# You will get the list of buckets found by above cmd 

# Slurp - single domain s3 buckets enumerator

# S3scanner - scan the S3 							buckets for sensitive files.


# AWSBucketDump.py - scans the access and download the files
# python3 AWSBucketDump.py -l ../buckets.txt -g interesting_Keywords.txt -D -m 500000 -d 1


# Cloudbrute - same as cloud enum but more defined
## All providers search
# ~/tools/cb/cloudbrute -d $1 -k $2 -m storage -t 80 -T 10 -w "~/tools/cb/data/storage_small.txt"
# ~/tools/cb/cloudbrute -d $1 -k $2 -m storage -t 80 -T 10 -w "~/tools/cb/data/storage_large.txt"
# ~/tools/cb/cloudbrute  -d $1 -k $2 -m storage -t 80 -T 10 -w "~/recon/cloud-assets/words.txt" -D -C ~/tools/cb/config
## Specific provider search
# CloudBrute -d target.com -k keyword -m storage -t 80 -T 10 -w -c amazon -o target_output.txt


