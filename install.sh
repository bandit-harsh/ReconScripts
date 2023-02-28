#!/bin/bash
sudo apt-get -y update
sudo apt-get -y upgrade


sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y libssl-dev
sudo apt-get install -y jq
sudo apt-get install -y ruby-full
sudo apt-get install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
sudo apt-get install -y build-essential libssl-dev libffi-dev python-dev
sudo apt-get install -y python-setuptools
sudo apt-get install -y libldns-dev
sudo apt-get install -y python python3-pip
sudo apt-get install -y python-dnspython
sudo apt-get install -y git
sudo apt-get install -y rename
sudo apt-get install -y xargs
sudo apt-get install -y python python3-pip
sudo apt-get install -y golang-go
mkdir ~/tools
echo "Install S3scanner"
sudo pip3 install s3scanner


#Don't forget to set up AWS credentials!
echo "Don't forget to set up AWS credentials!"
apt install -y awscli
echo "Don't forget to set up AWS credentials!"



#create a tools folder in ~/
mkdir ~/tools
cd ~/tools/

#install httpx
wget https://github.com/projectdiscovery/httpx/releases/download/v1.2.6/httpx_1.2.6_linux_amd64.zip ; unzip httpx_1.2.6_linux_amd64.zip; sudo mv httpx /bin/

#download permutation list for gotator
mkdir resources
wget https://gist.githubusercontent.com/six2dez/ffc2b14d283e8f8eff6ac83e20a3c4b4/raw -O resources/permutation.txt
#install massdns
git clone https://github.com/blechschmidt/massdns.git;cd massdns;make;sudo make install;cd ..

#install Fin
wget https://github.com/Findomain/Findomain/releases/download/8.2.1/findomain-linux.zip; unzip findomain-linux.zip;chmod +x findomain;sudo mv findomain /bin/
wget https://github.com/OWASP/Amass/releases/download/v3.21.2/amass_linux_amd64.zip ; unzip amass_linux_amd64.zip; chmod +x amass_linux_amd64/amass;sudo mv amass_linux_amd64/amass /bin/
git clone https://github.com/vortexau/dnsvalidator.git;cd dnsvalidator;sudo python3 setup.py install;cd ..


#install aquatone
echo "Installing Aquatone"
go install github.com/michenriksen/aquatone@latest
echo "done"

#install chromium
echo "Installing Chromium"
sudo snap install chromium
echo "done"

echo "installing JSParser"
git clone https://github.com/nahamsec/JSParser.git
cd JSParser*
sudo python setup.py install
cd ~/tools/
echo "done"

echo "installing Sublist3r"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r*
pip3 install -r requirements.txt
cd ~/tools/
echo "done"

echo "installing CloudBrute";mkdir cb;cd cb;wget https://github.com/0xsha/CloudBrute/releases/download/v1.0.7/cloudbrute_1.0.7_Linux_x86_64.tar.gz;tar xvf cloudbrute_1.0.7_Linux_x86_64.tar.gz;cd ~/tools/;echo "done"

echo "Installing Slurp";git clone https://github.com/0xbharath/slurp.git; cd slurp; wget https://github.com/0xbharath/slurp/releases/download/1.1.0/slurp-1.1.0-linux-amd64;cd ~/tools/;echo "done"
echo "installing Cloud_enum"
git clone https://github.com/initstring/cloud_enum.git
cd cloud_enum
pip3 install -r requirements.txt
cd ~/tools/
echo "done"


echo "installing teh_s3_bucketeers"
git clone https://github.com/tomdev/teh_s3_bucketeers.git
cd ~/tools/
echo "done"


echo "installing wpscan"
git clone https://github.com/wpscanteam/wpscan.git
cd wpscan*
sudo gem install bundler && bundle install --without test
cd ~/tools/
echo "done"

echo "installing dirsearch"
git clone https://github.com/maurosoria/dirsearch.git
cd ~/tools/
echo "done"


echo "installing lazys3"
git clone https://github.com/nahamsec/lazys3.git
cd ~/tools/
echo "done"

echo "installing virtual host discovery"
git clone https://github.com/jobertabma/virtual-host-discovery.git
cd ~/tools/
echo "done"


echo "installing sqlmap"
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
cd ~/tools/
echo "done"

echo "installing knock.py"
git clone https://github.com/guelfoweb/knock.git
cd ~/tools/
echo "done"

echo "installing lazyrecon"
git clone https://github.com/nahamsec/lazyrecon.git
cd ~/tools/
echo "done"

echo "installing nmap"
sudo apt-get install -y nmap
echo "done"

echo "installing massdns"
git clone https://github.com/blechschmidt/massdns.git
cd ~/tools/massdns
make
cd ~/tools/
echo "done"

echo "installing asnlookup"
git clone https://github.com/yassineaboukir/asnlookup.git
cd ~/tools/asnlookup
pip install -r requirements.txt
cd ~/tools/
echo "done"

echo "installing httprobe"
go install -u github.com/tomnomnom/httprobe@latest
echo "done"

echo "installing unfurl"
go install -u github.com/tomnomnom/unfurl@latest
echo "done"

echo "installing waybackurls"
go install github.com/tomnomnom/waybackurls@latest
echo "done"

 go install github.com/Josue87/gotator@latest
 go install github.com/Emoe/kxss@latest
 go install github.com/tomnomnom/assetfinder@latest
 go install github.com/tomnomnom/waybackurls@latest
# sudo pacman -S nuclei nuclei-templates
 go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei
 go install github.com/Josue87/gotator@latest
 go install github.com/lc/gau/v2/cmd/gau@latest
 go install github.com/tomnomnom/unfurl@latest
 go install github.com/tomnomnom/httprobe@latest
 go install github.com/gwen001/github-subdomains@latest
 go install github.com/glebarez/cero@latest
 go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
 go install github.com/hvs-consulting/SANextract
 go install github.com/d3mondev/puredns/v2@latest

echo "installing crtndstry"
git clone https://github.com/nahamsec/crtndstry.git
echo "done"

echo "downloading Seclists"
cd ~/tools/
git clone https://github.com/danielmiessler/SecLists.git
cd ~/tools/SecLists/Discovery/DNS/
##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
cd ~/tools/
echo "done"



echo -e "\n\n\n\n\n\n\n\n\n\n\nDone! All tools are set up in ~/tools"
ls -la
echo "One last time: don't forget to set up AWS credentials in ~/.aws/!"
echo "Use and install S3scanner and slurp and also do the mobile endpoint extraction yourself"
