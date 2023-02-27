# Subdomain Bruteforce
$3 - resolver list
~/go/bin/puredns bruteforce ~/tools/SecLists/Discovery/DNS/dns-Jhaddix.txt $1 -r $3 -w ~/recon/active-recon/bruteforce.txt --bin ~/tools/massdns/bin/massdns
mkdir ~/recon/active-recon
# Uptill now we have two lists final-passive-resolved.txt and bruteforce.txt
# Mergeing then and fetched the 302 redirected sites
cat ~/recon/passive-recon/final-passive-resolved.txt bruteforce.txt | sort -u | tee -a subdomain.txt

echo "Do the TLS SAN manually with the help of subdomain.txt"

~/go/bin/puredns resolver subdomain.txt -r $3 -w Resolved.txt

# Permutation and altration of the subdomains

~/go/bin/gotator -sub Resolved.txt -perm ~/tools/resources/permutation.txt -depth 1 -numbers 10 -mindup -adv -md > gotator1.txt
~/go/bin/puredns resolve gotator1.txt -r $3 -w ~/recon/active-recon/final-Resolved.txt 

# Gen of Priority wordlist from ~/recon/passive-recon/final.txt ~/recon/active-recon/bruteforce.txt ~/recon/active-recon/final-Resolved.txt
# For Bucket Finding and bruteforce
mkdir ~/recon/cloud-assets
cat ~/recon/passive-recon/final.txt ~/recon/active-recon/bruteforce.txt ~/recon/active-recon/final-Resolved.txt | sed 's/\./\n/g' | sort -u | tee -a ~/recon/cloud-assets/words.txt

