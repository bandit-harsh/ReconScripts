# Gen of Priority wordlist from ~/recon/passive-recon/final.txt ~/recon/active-recon/bruteforce.txt ~/recon/active-recon/final-Resolved.txt
# For Bucket Finding and bruteforce
echo "Make sure you have setup the awscli"
mkdir ~/recon/cloud-assets
cat ~/recon/passive-recon/final.txt ~/recon/active-recon/bruteforce.txt ~/recon/active-recon/final-Resolved.txt | sed 's/\./\n/g' | sort -u | tee -a ~/recon/cloud-assets/words.txt

echo "You have to do it manually by giving commands in comments."
# Cloudbrute - same as cloud enum but more defined
## All providers search
# CloudBrute -d target.com -k target -m storage -t 80 -T 10 -w "./data/storage_small.txt"
# CloudBrute -d target.com -k target -m storage -t 80 -T 10 -w "./data/storage_large.txt"
# CloudBrute -d target.com -k target -m storage -t 80 -T 10 -w "~/recon/cloud-assets/words.txt"
## Specific provider search
# CloudBrute -d target.com -k keyword -m storage -t 80 -T 10 -w -c amazon -o target_output.txt


# cloud_enum.py -k nxp -k nxp.com -k semiconductors
# You will get the list of buckets found by above cmd 

# Slurp - single domain s3 buckets enumerator
# slurp domain -p permutations.json -t nxp.com -c 25

# S3scanner - scan the S3 buckets for sensitive files.
# S3scanner scan --buckets-file buckets.txt

# AWSBucketDump.py - scans the access and download the files
# python3 AWSBucketDump.py -l ../buckets.txt -g interesting_Keywords.txt -D -m 500000 -d 1



