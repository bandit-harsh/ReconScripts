mkdir ~/recon/External-IPs/
RED='\033[0;31m'
NC='\033[0m' 

echo -e "${RED}Make sure you have searched for CIDR on bgp.he. ${NC}"
echo "\n"
echo "Drop the list with filename 'cidrs.txt' in the current directory to get the resolved IPs."

~/tools/hardcidr/hardCIDR.sh
echo /tmp/nxp/cirdrange.txt | ~/go/bin/mapcidr -silent | ~/go/bin/dnsx -ptr -resp-only -r ~/tools/resources/resolvers.txt -o output.txt
echo ./cidr.txt | ~/go/bin/mapcidr -silent | ~/go/bin/dnsx -ptr -resp-only -r ~/tools/resources/resolvers.txt -o output.txt
