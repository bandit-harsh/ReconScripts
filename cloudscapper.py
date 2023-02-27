import scrapy
from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors.lxmlhtml import LxmlLinkExtractor
from scrapy.crawler import CrawlerProcess

#import boto3
import os
from argparse import ArgumentParser
import requests
import time
import logging

from urlparse import urlparse

import dns
import sys

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

__author__ = '@TweekFawkes'
__website__ = 'Stage2Sec.com'
__blog__ = 'https://Stage2Sec.com/blog/'

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

'''

--- LolrusLove - Spider for Bucket Enumeration (AWS S3 Bucket, Azure Blob Storage, DigitalOcean Spaces, etc...) - Alpha v0.0.6 ---

Spiders a website looking for links to known FQDNs used by s3 like bucket services (AWS, Azure, Digital Ocean).
Useful for bucket hijacking and takeovers.

v0.0.6 - Added in DNS lookups for FQDNs to see if they are an alias record for an s3 buckets (e.g. CNAME checks)

TODO:
- Automatically check via the API if the AWS s3 bucket is already registered (e.g. hijacking)


--- Example Usage ---

... look at the help ...
$ lolrusLove-v0_0_6.py -h

... set your AWS API keys so LolrusLove can check if the S3 bucket is already registered ...
$ export AWS_ACCESS_KEY_ID="REDACTED"
$ export AWS_SECRET_ACCESS_KEY="REDACTED"
$ printenv | grep "AWS_"

... Python 2.7.6 (default, Oct 26 2016, 20:30:19) ...
$ python lolrusLove-v0_0_6.py https://example.com/
... you can ignore screen output for the most part ...

$ head 20171127_142706-bucket_urls.txt
... you should see a list of urls with the complete bucket names found via the spider ...  
# 20171127_142706 [+] START URL: https://example.com/
https://example.blob.core.windows.net/python-example/example.7z
...


--- Setup on Ubuntu 14.04 x64 ---

apt-get update
apt-get -y install python
apt-get -y install python-pip
pip3 install boto3

pip3 install -U pip setuptools
pip3 install pyOpenSSL
pip3 install scrapy
pip3 install enum34
pip3 install cryptography

apt-get -y install python-requests

...
$ python 
Python 2.7.6 (default, Oct 26 2016, 20:30:19)
...
>>> exit()


--- References ---

- Example: Setting up a Static Website Using a Custom Domain
-- http://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html

- Scraping a domain for links recursively using Scrapy
-- https://stackoverflow.com/questions/46741211/scraping-a-domain-for-links-recursively-using-scrapy

'''

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

# User Defined Variables
#os.environ["AWS_ACCESS_KEY_ID"] = 'REDACTED' # INSECURE # It is better to set these as environment variables using the export command, for example: export AWS_ACCESS_KEY_ID="REDACTED"
#os.environ["AWS_SECRET_ACCESS_KEY"] = 'REDACTED' # INSECURE # It is better to set these as environment variables using the export command, for example: export AWS_SECRET_ACCESS_KEY="REDACTED"

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

# Automatically Defined Variables
sScriptName = os.path.basename(__file__)
sLogDirectory = 'logs'
sVersion = 'Alpha v0.0.6'
sUserAgentString = 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)'
lKeywords = ['windows.net', 'amazonaws.com', 'digitaloceanspaces.com']

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

# Get the Arguments
parser = ArgumentParser(add_help=True)

parser.add_argument('url', 
                    action="store",
                    help="[required] url e.g.: https://marketing.example.com/developer")
parser.add_argument("-v", "--verbose",
                    action="store_false", dest="fVerbose", default=False,
                    help="print verbose status messages to stdout")
parser.add_argument("-d", "--debug",
                    action="store_false", dest="fDebug", default=False,
                    help="save debug status messages to a file")                    

args = parser.parse_args()

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

# Start Logging
if not os.path.exists(sLogDirectory):
    os.makedirs(sLogDirectory)

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

# Logging to a file
if args.fDebug is True:
    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(name)-12s %(levelname)-8s %(message)s',
                        datefmt='%m-%d %H:%M',
                        filename=sLogDirectory+"/"+str(int(time.time()))+'-'+sScriptName+'.log',
                        filemode='w')
elif args.fDebug is False:
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s %(name)-12s %(levelname)-8s %(message)s',
                        datefmt='%m-%d %H:%M',
                        filename=sLogDirectory+"/"+str(int(time.time()))+'-'+sScriptName+'.log',
                        filemode='w')
logger = logging.getLogger(__name__)

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

'''
CRITICAL	50
ERROR	40
WARNING	30
INFO	20
DEBUG	10
NOTSET	0

logging.debug("DEBUG")
logging.info("INFO")
logging.warning("WARNING")
logging.error("ERROR")
logging.critical("CRITICAL")
'''

# Logging to a stdout
console = logging.StreamHandler()

if args.fVerbose is True:
    console.setLevel(logging.DEBUG)
    fSpiderLoggingFlag = True
elif args.fVerbose is False:
    console.setLevel(logging.CRITICAL)
    fSpiderLoggingFlag = False
    #console.setLevel(logging.WARNING) # this is what it was

formatter = logging.Formatter('%(name)-12s: %(levelname)-8s %(message)s')
console.setFormatter(formatter)
logging.getLogger('').addHandler(console)

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

logging.critical("""

888              888                           888                                
888              888                           888                                
888              888                           888                                
888      .d88b.  888 888d888 888  888 .d8888b  888      .d88b.  888  888  .d88b.  
888     d88""88b 888 888P"   888  888 88K      888     d88""88b 888  888 d8P  Y8b 
888     888  888 888 888     888  888 "Y8888b. 888     888  888 Y88  88P 88888888 
888     Y88..88P 888 888     Y88b 888      X88 888     Y88..88P  Y8bd8P  Y8b.     
88888888 "Y88P"  888 888      "Y88888  88888P' 88888888 "Y88P"    Y88P    "Y8888  
                                                                                  
                                                                                  
                                                                                  

""")

logging.critical("Alpha v0.0.6\n")

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

sStartUrl = str(args.url).strip()
logging.critical("[+] sStartUrl: "+sStartUrl)

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

def getTheDomainFromTheUrl( sUrl ):
    parsed_uri = urlparse( sUrl )
    sAllowedDomain = parsed_uri.netloc
    return sAllowedDomain

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

sAllowedDomain = getTheDomainFromTheUrl( sStartUrl )
logging.critical("[+] sAllowedDomain: "+sAllowedDomain)

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

from time import gmtime, strftime
sCurrentTime = strftime("%Y%m%d_%H%M%S", gmtime())

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

sOutputFileName = sCurrentTime + '-bucket_urls.txt'
file = open(sOutputFileName,'w')
file.write('# ' + sCurrentTime + ' [+] START URL: ' + sStartUrl + "\n")
file.close()

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

def logTheUrl(sUrl):
    file = open(sOutputFileName, 'a')
    file.write(sUrl + "\n")
    file.close()

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

def uniqList(lUniqDomains):
   setUniqDomains = set(lUniqDomains)
   return list(setUniqDomains)

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

lUniqDomains = []
lUniqDomains.append( sAllowedDomain )
lUniqDomains = uniqList(lUniqDomains)

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

logging.critical("[+] lKeywords: " + str(lKeywords))

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

class UrlsSpider(scrapy.Spider):
    name = 'lolrusLove'
    allowed_domains = [sAllowedDomain]
    start_urls = [sStartUrl]

    rules = (Rule(LxmlLinkExtractor(allow=(), unique=True), callback='parse', follow=True))

    def parse(self, response):
        for link in LxmlLinkExtractor(deny_domains=self.allowed_domains, unique=True).extract_links(response):
            sUrl = str(link.url)
            logging.critical("[+] sUrl: " + sUrl)
            for sKeyword in lKeywords:
                if sKeyword in sUrl:
                    logging.critical("[+] link.url: " + link.url)
                    logTheUrl(link.url)
            try:
                from urlparse import urlparse
                parsed = urlparse(sUrl)
                print parsed.hostname
                try:
                    answers = dns.resolver.query(parsed.hostname, 'CNAME')
                    print ' query qname:', answers.qname, ' num ans.', len(answers)
                    for rdata in answers:
                        print ' cname target address:', rdata.target
                except:
                    print "002 - Unexpected error:", sys.exc_info()[0]
            except:
                print "001 - Unexpected error:", sys.exc_info()[0]

        
        for link in LxmlLinkExtractor(allow_domains=self.allowed_domains, unique=True).extract_links(response):
            yield scrapy.Request(link.url, callback=self.parse)
            #print "!!!"

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

process = CrawlerProcess({
    'USER_AGENT': sUserAgentString
})

process.crawl(UrlsSpider)
process.start() # the script will block here until the crawling is finished

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #