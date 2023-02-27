~/tools/hardCIDR.sh
echo /tmp/nxp/cirdrange.txt | ~/go/bin/mapcidr -silent | ~/go/bin/dnsx -ptr -resp-only -r resolver.txt -o output.txt
